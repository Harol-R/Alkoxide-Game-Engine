package main

import "vendor:glfw"
import gl "vendor:OpenGL"
import "core:fmt"
import "core:c"

windowHandle :: glfw.WindowHandle

window::proc(name:cstring, width, height: c.int, vsync:bool)-> windowHandle{
    // Inicializar GLFW
    if ! cast(bool) glfw.Init() {
        // log error, exit
        return nil
    }

    // Configurar versión de OpenGL (3.3 Core)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 3)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
    glfw.WindowHint(glfw.SAMPLES , 8)


    // Crear ventana
    window := glfw.CreateWindow(width, height, name, nil, nil)
    if window == nil {
        fmt.println("Error al crear ventana GLFW")
        return nil
    }

    glfw.MakeContextCurrent(window)
    
    gl.load_up_to(3, 3, proc(p: rawptr, name: cstring) {
	(cast(^rawptr)p)^ = glfw.GetProcAddress(name)
    })
    
    glfw.SwapInterval(i32(vsync))
    gl.Enable(gl.MULTISAMPLE)

    glfw.SetFramebufferSizeCallback(window, size_callback)

    return window
}



/*https://rgbcolorpicker.com/0-1 
    Only RBG format
*/
setBackgroundColor :: proc(red,green,blue:f32){
    r:= red/255
    g:= green/255
    b:= blue/255

    gl.ClearColor(r, g, b, 1.0)
}

pollEvents :: proc(){
    glfw.PollEvents()
    //gl.ClearColor(0.9, 0.2, 0.8, 1) // Pink: 0.9, 0.2, 0.8
    gl.Clear(gl.COLOR_BUFFER_BIT)
    gl.Enable(gl.BLEND)
    gl.BlendFunc(gl.SRC_ALPHA,gl.ONE_MINUS_SRC_ALPHA)
}

close :: proc(win: windowHandle){
    glfw.DestroyWindow(win)
    glfw.Terminate()
}

shouldWindowClose :: proc(window: windowHandle) -> b32{
    return glfw.WindowShouldClose(window)
}

size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	// Set the OpenGL viewport size
	gl.Viewport(0, 0, width, height)
}

swapBuffers :: proc(win:windowHandle){
    glfw.SwapBuffers(win)
}