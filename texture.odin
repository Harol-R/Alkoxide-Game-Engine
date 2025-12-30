package main

import stbi "vendor:stb/image"
import gl "vendor:OpenGL"
import "core:fmt"

//Solo imagenes .png, ONLY PNG IMAGES 
LoadTexture::proc(file_path:cstring,interpolation:bool) -> (texture:u32, success:bool) {
    
    stbi.set_flip_vertically_on_load(1)
    
    //we create a single texture and store it on the unasigned u32 
    //   Number of textures | were to store the texture
    gl.GenTextures(1 , &texture)
    gl.BindTexture(gl.TEXTURE_2D, texture)

    //configure texture parameters | interpolation
    if interpolation == false{
        gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT)
        gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT)
        gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST_MIPMAP_NEAREST)
        gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST)
    }
    else{
        gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT)
        gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT)
        gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR)
        gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
    }

    width, height, nrChannels:i32
    data:= stbi.load(file_path, &width, &height, &nrChannels,4)
    defer stbi.image_free(data)

    if data == nil{
        fmt.eprintf("ERROR:: Failed to load texture: %s\n", file_path)
        return 0, false
    }

    gl.TexImage2D(gl.TEXTURE_2D,0, gl.RGBA8 ,width,height, 0, gl.RGBA, gl.UNSIGNED_BYTE, rawptr(data))

    gl.GenerateMipmap(gl.TEXTURE_2D)

    return texture, true

}

deleteTexture :: proc(tex:^u32){
    gl.DeleteTextures(1,tex)
    fmt.printfln("TEXTURE CLEANED")
}