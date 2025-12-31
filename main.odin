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

    shader:= loadShader("fragment.frag","vertex.vert")

    square:= createSquare(shader)
    defer cleanSquare(&square)

    image, ok:= LoadTexture("image.png", false)
    if ok == false{
        return
    }
    defer deleteTexture(&image)

    camera:= camera2d(window)

    uvGridsize:vec2 = {1,1}


    for !shouldWindowClose(window){
        pollEvents()
        

        updateCam2d(&camera,window)
        
        setBackgroundColor(255, 255, 255)

        renderQ(square,image,uvGridsize,camera)


        setUvOffset(shader,uvGridsize,{0,0})
        
        swapBuffers(window)
        
    }
}