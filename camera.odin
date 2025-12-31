package main

import "vendor:glfw"
import gl "vendor:OpenGL"

import mt "core:math/linalg/glsl"

cameraData2d :: struct{
    viewMatrix, projectionMatrix, viewProjectionMatrix:mat4,
    position:vec3,
    rotation:f32
}

//create a 2d camera
camera2d :: proc(win:windowHandle) -> cameraData2d{
    using mt

    camera:cameraData2d
    width, height:= glfw.GetWindowSize(win)
    projection: = mat4Ortho3d(f32(-width/2), f32(width/2), f32(-height/2), f32(height/2), -200,100)

    return cameraData2d {projectionMatrix = projection, position = {0,0,0}, rotation = 0,viewMatrix = mat4{}}
}

updateCam2d :: proc(cam:^cameraData2d,win:windowHandle){
    using mt
    
    pos:[3]f32 = {cam.position.x,cam.position.y, cam.position.z}

    translation := mat4Translate(-pos)
    rotation     := mat4Rotate(vec3{0, 0, 1}, -cam.rotation)

    width, height:= glfw.GetWindowSize(win)
    projection: = mat4Ortho3d(f32(-width/2), f32(width/2), f32(-height/2), f32(height/2), -200,100)
    cam.projectionMatrix = projection

    cam.viewMatrix = translation * rotation

}