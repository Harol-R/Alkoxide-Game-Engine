package main

import gl "vendor:OpenGL"


// for some reason this was SOOO HARD to do that i had to use AI for shaders
vertexAtribute :: proc(location:u32,componentNum:i32,offset_byte:int){
    stride:i32 = 4 * size_of(f32) //x, y and uv cambia este parametro si es nesesario
    
    gl.VertexAttribPointer(
        location, 
        componentNum, 
        gl.FLOAT, 
        false, 
        stride, 
        uintptr(offset_byte))
    
    gl.EnableVertexAttribArray(location)
}
 

createVAO :: proc() -> u32{
    vaoNew:u32
    gl.GenVertexArrays(1, &vaoNew)
    gl.BindVertexArray(vaoNew)
    return vaoNew
}

createVBO :: proc(vertices:[]f32) -> u32{
    vboNew:u32
    gl.GenBuffers(1, &vboNew)
    gl.BindBuffer(gl.ARRAY_BUFFER, vboNew)
    gl.BufferData(gl.ARRAY_BUFFER, cast(int)(len(vertices)*size_of(f32)), raw_data(vertices), gl.STATIC_DRAW)
    return vboNew
}

createEBO :: proc(indices:[]u32) -> u32{
    eboNew:u32
    gl.GenBuffers(1,&eboNew)
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, eboNew)
    gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, cast(int)(len(indices)*size_of(u32)) , raw_data(indices),gl.STATIC_DRAW)
    return eboNew
}