package main

import "core:fmt"
import "vendor:glfw"
import gl "vendor:OpenGL"

vec2 :: struct{
    x,y:f32
}

vec3 :: struct{
    x,y,z:f32
}

vec4 :: struct{
    x,y,z,w:f32
}
 

main :: proc() {
    window:= window("window",800,400, true)
    defer close(window)

    square:= createSquare()
    defer cleanObject(&square)
    

    shader:= loadShader("fragment.frag","vertex.vert")
    defer deleteShader(shader)


    for !shouldWindowClose(window){
        pollEvents()
        
        renderQ(square,shader)
        
        swapBuffers(window)
        
    }
}