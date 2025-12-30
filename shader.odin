package main

import gl "vendor:OpenGL"
import "core:os"
import "core:strings"
import "core:fmt"
import mt "core:math/linalg/glsl"


//creates a Shader program, 
//sources used https://learnopengl.com/Getting-started/Shaders
loadShader::proc(fragmentPath:string,vertexPath:string) -> u32{

    success:i32
    infolog:[^]u8

    //loading vertex shader
    vertx_data , vertx_ok:= os.read_entire_file(vertexPath)
    if vertx_data == nil do fmt.panicf("VERTEX SHADER COULD NOT BE LOADED %s", vertexPath)
    defer delete(vertx_data)
    vertx_source:= strings.clone_to_cstring(string(vertx_data))
    defer delete(vertx_source)

    
    //loading fragment shader
    fragData, frag_ok:= os.read_entire_file(fragmentPath)
    if fragData == nil do fmt.panicf("FRAGMENT SHADER COULD NOT BE LOADED %s", fragmentPath)
    defer delete(fragData)
    frag_source:= strings.clone_to_cstring(string(fragData))
    defer delete( frag_source)

    
    // Compilar shaders
    //compilar vertex shader
    vertex_shader := gl.CreateShader(gl.VERTEX_SHADER)
    gl.ShaderSource(vertex_shader, 1, &vertx_source, nil)
    gl.CompileShader(vertex_shader)
    
    //print vertex shader errors
    gl.GetShaderiv(vertex_shader,gl.COMPILE_STATUS,&success)
    if success == 0{
        gl.GetShaderInfoLog(vertex_shader,512,nil,infolog)
        fmt.panicf("COMPILATION OF VERTEX SHADER FAILED\n ", infolog)
    }

    
    //Compilar fragment shader
    fragment_shader := gl.CreateShader(gl.FRAGMENT_SHADER)
    gl.ShaderSource(fragment_shader, 1, &frag_source, nil)
    gl.CompileShader(fragment_shader)

    //print fragment shader errors
    gl.GetShaderiv(fragment_shader,gl.COMPILE_STATUS,&success)
    if success == 0{
        gl.GetShaderInfoLog(fragment_shader,512,nil,infolog)
        fmt.panicf("COMPILATION OF FRAGMENT SHADER FAILED\n ", infolog)
    }

    
    // Crear programa de shaders
    //el programa shaders guarda el vertex y fragment shader en uno
    shader_program := gl.CreateProgram()
    gl.AttachShader(shader_program, vertex_shader)
    gl.AttachShader(shader_program, fragment_shader)
    gl.LinkProgram(shader_program)

    // Shader program linking error checking
    //verificar errores de shader linkinng 
    gl.GetProgramiv(shader_program,gl.LINK_STATUS,&success)
    if success == 0{
        gl.GetShaderInfoLog(shader_program, 512, nil, infolog)
        fmt.panicf("ERROR SHADER LINKING FAILED\n ", infolog)
    }

    
    gl.DeleteShader(vertex_shader)
    gl.DeleteShader(fragment_shader)

    return shader_program
}

useShader :: proc(program:u32){ gl.UseProgram(program) }

deleteShader :: proc(program:u32){ gl.DeleteProgram(program) }

//chnage uniform value on a shader
setShaderValue :: proc(program:u32,name:cstring,value:any){
    
    location:= gl.GetUniformLocation(program,name)
    
    //error checking
    if location == -1 do return
    
    if value.id == typeid_of(bool){
        //https://stackoverflow.com/questions/33690186/opengl-bool-uniform
        gl.Uniform1i(location,(^i32)(value.data)^)
    }
    //int, i32, or i64 (whole numbers) case
    if value.id == typeid_of(int) || value.id == typeid_of(i32) || value.id == typeid_of(i64){
        //cast the value (int, i32, or i64) to i64 and then i32 to prevent type errors.
        gl.Uniform1i(location,i32((^i64)(value.data)^))
    }
    //float case, f32
    if value.id == typeid_of(f32){
        gl.Uniform1f(location,(^f32)(value.data)^)
    }
    //float case,f64
    if value.id == typeid_of(f64){
        gl.Uniform1d(location,(^f64)(value.data)^)
    }
    //f32 vector 2 (x,y)
    if value.id == typeid_of(vec2){
        v:= (^vec2)(value.data)^
        gl.Uniform2f(location, v.x, v.y)
    }
    //f32 vector 3 (x,y,z)
    if value.id ==  typeid_of(vec3){
        v:= (^vec3)(value.data)^
        gl.Uniform3f(location,v.x, v.y, v.z)
    }
    //f32 vector 4 (x.y.z.w)
    if value.id == typeid_of(vec4){
        v:= (^vec4)(value.data)^
        gl.Uniform4f(location, v.x, v.y, v.z, v.w)
    }
    // matrix 4x4
    if value.id == typeid_of(mat4){
        m:= (^mat4)(value.data)^
        gl.UniformMatrix4fv(location,1, gl.FALSE, &m[0][0])
    }
}

