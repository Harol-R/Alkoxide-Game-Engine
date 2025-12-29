package main

import gl "vendor:OpenGL"


// for some reason this was SOOO HARD to do that i had to use AI 
vertexAtribute :: proc(location:u32,componentNum:i32,offset_float:int){
    gl.VertexAttribPointer(
        location, 
        componentNum, 
        gl.FLOAT, 
        false, 
        8 * size_of(f32), 
        uintptr(offset_float * size_of(f32)))
    gl.EnableVertexAttribArray(location)
}
