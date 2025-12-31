package main

import "core:fmt"
import "core:sys/wasm/js"
import gl "vendor:OpenGL"
import mt "core:math/linalg/glsl"
import "core:math"

vertices := []f32{
    -100, -100,  0.0, 0.0,  // abajo-izquierda
    100, -100,  1.0, 0.0,  // abajo-derecha
    100,  100,  1.0, 1.0,  // arriba-derecha
    -100,  100,  0.0, 1.0,  // arriba-izquierda
}

indices := []u32{0, 1, 2, 2, 3, 0}

square :: struct {
    vao,ebo,vbo:u32,
    index_count:i32,
    shader:u32,
    position:vec2,
    rotation:f32,
    scale:vec2
}

renderQ :: proc(data:square,texture:u32,uvGrid:vec2 = {1,1},cam:cameraData2d){
    //use shader we call the use shader before uploading the data to opengl to tell it that the next information given its a vao
    useShader(data.shader)
    
    model:= mt.mat4Translate(mt.vec3{data.position.x,data.position.y,0}) * mt.mat4Rotate({0,0,1},math.to_radians(data.rotation)) * mt.mat4Scale(mt.vec3{data.scale.x, data.scale.y, 0})

    setShaderValue(data.shader,"model",model)

    //send image
        
    gl.ActiveTexture(gl.TEXTURE0)
    gl.BindTexture(gl.TEXTURE_2D, texture)
    gl.Uniform1i(gl.GetUniformLocation(data.shader, "texture1"),0)
    
    setUvScale(data.shader,uvGrid)
    
    //camera
    setShaderValue(data.shader, "view", cam.viewMatrix)
    setShaderValue(data.shader, "projection", cam.projectionMatrix)

    
    //draw
    gl.BindVertexArray(data.vao)
    gl.DrawElements(gl.TRIANGLES, data.index_count, gl.UNSIGNED_INT, nil)
}

createSquare :: proc(shader:u32) -> square{
    vao:= createVAO()
    vbo:= createVBO(vertices)
    ebo:= createEBO(indices)

    vertexAtribute(0,2,0) // position vertext atribute
    vertexAtribute(1,2,2 * size_of(f32)) // uv vertex atribute

    return square {vao = vao, vbo = vbo, ebo = ebo, index_count = i32(len(indices)), shader = shader, position = {0,0}, scale = {1,1}}
}

cleanSquare :: proc(data:^square){
    deleteShader(data.shader)
    gl.DeleteBuffers(1, &data.ebo) 
    gl.DeleteBuffers(1,&data.vbo)
    gl.DeleteVertexArrays(1, &data.vao)
}


//columnas y linias divido por 1 | 1/4 = 0.25 for x and y
setUvScale :: proc(shader:u32,scal:vec2){
    v:vec2
    v.x = 1 / scal.x
    v.y = 1 / scal.y
    setShaderValue(shader,"uvScale",v)
}
setUvOffset :: proc(shader:u32,uvgrid:vec2 ,offset:vec2){
    //           colum                                         row
    v:= vec2{ f32(offset.x) * (1.0/ f32(uvgrid.x)), f32(offset.y) * (1.0 / f32(uvgrid.y))}

    setShaderValue(shader, "uvOffset",v)
}


/*cols:: 2
    rows:: 2

    collun :: 1
    row :: 0


    offset:= vec2{f32(collun) * (1.0/ f32(cols)), f32(row) * (1.0 / f32(rows))}
    
    */