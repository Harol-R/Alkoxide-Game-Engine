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

renderQ :: proc(data:square,shader:u32){
    useShader(shader)
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

cleanObject :: proc(data:^square){
    gl.DeleteBuffers(1, &data.ebo) 
    gl.DeleteBuffers(1,&data.vbo)
    gl.DeleteVertexArrays(1, &data.vao)
}

