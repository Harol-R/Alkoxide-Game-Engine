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
    window:= window("window",800,800, true)
    defer close(window)

    square:= createSquare()
    defer cleanSquare(&square)

    image, ok:= LoadTexture("image.png", false)
    if ok == false{
        return
    }
    defer deleteTexture(&image)

    shader:= loadShader("fragment.frag","vertex.vert")
    defer deleteShader(shader)


    for !shouldWindowClose(window){
        pollEvents()

        setBackgroundColor(0.9, 0.2, 0.8, 1.0)

        setUvScale(shader,{0.5,0.5})
        setUvOffset(shader,{0,0.5})
        
        renderQ(square,shader,image)
        
        swapBuffers(window)
        
    }
}