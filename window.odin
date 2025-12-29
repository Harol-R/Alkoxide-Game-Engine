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


/*initEvents::proc(){
    glfw.PollEvents()
    
    gl.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    
    //activa texturas transparentes & activa face culling
    gl.Enable(gl.BLEND | gl.CULL_FACE)
    gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
    
    gl.Enable(gl.DEPTH_TEST)
    gl.ClearColor(0.2, 0.3, 0.3, 1.0);
    
    //configura como Cull Fa
    gl.CullFace(gl.BACK)
    gl.FrontFace(gl.CCW)
}
*/

pollEvents :: proc(){
    glfw.PollEvents()
    gl.ClearColor(0.9, 0.2, 0.8, 1) // Pink: 0.9, 0.2, 0.8
    gl.Clear(gl.COLOR_BUFFER_BIT)
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