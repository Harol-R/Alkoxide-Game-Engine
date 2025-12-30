package main

import "core:sys/wasm/js"
import gl "vendor:OpenGL"

vertices := []f32{
    -0.5, -0.5,  0.0, 0.0,  // abajo-izquierda
    0.5, -0.5,  1.0, 0.0,  // abajo-derecha
    0.5,  0.5,  1.0, 1.0,  // arriba-derecha
    -0.5,  0.5,  0.0, 1.0,  // arriba-izquierda
}

indices := []u32{0, 1, 2, 2, 3, 0}

square :: struct {
    vao,ebo,vbo:u32,
    index_count:i32
}


renderQ :: proc(data:square,shader:u32,texture:u32){
    //use shader we call the use shader before uploading the data to opengl to tell it that the next information given its a vao
    useShader(shader)
    
    //send image
        
    gl.ActiveTexture(gl.TEXTURE0)
    gl.BindTexture(gl.TEXTURE_2D, texture)
    gl.Uniform1i(gl.GetUniformLocation(shader, "texture1"),0)
    
    
    //draw
    gl.BindVertexArray(data.vao)
    gl.DrawElements(gl.TRIANGLES, data.index_count, gl.UNSIGNED_INT, nil)
}

createSquare :: proc() -> square{
    vao:= createVAO()
    vbo:= createVBO(vertices)
    ebo:= createEBO(indices)

    vertexAtribute(0,2,0) // position vertext atribute
    vertexAtribute(1,2,2 * size_of(f32)) // uv vertex atribute

    return square {vao = vao, vbo = vbo, ebo = ebo, index_count = i32(len(indices))}
}

cleanSquare :: proc(data:^square){
    gl.DeleteBuffers(1, &data.ebo) 
    gl.DeleteBuffers(1,&data.vbo)
    gl.DeleteVertexArrays(1, &data.vao)
}


//columnas y linias divido por 1 | 1/4 = 0.25 for x and y
setUvScale :: proc(shader:u32,scal:vec2){
    setShaderValue(shader,"uvScale",scal)
}

setUvOffset :: proc(shader:u32, offset:vec2){
    setShaderValue(shader, "uvOffset",offset)
}
