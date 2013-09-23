import std.math,
       std.typecons;

import gfm.core.all,
       gfm.sdl2.all,
       gfm.opengl.all;

// This example show how to draw an OpenGL triangle

void main()
{
    int width = 1280;
    int height = 720;
    double ratio = width / cast(double)height;

    // create a default logger
    auto log = defaultLog();

    // load dynamic libraries
    auto sdl2 = scoped!SDL2(log);
    auto gl = scoped!OpenGL(log);

    // create an OpenGL-enabled SDL window
    auto window = scoped!SDL2Window(sdl2, 
                                    SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
                                    width, height,
                                    SDL_WINDOW_OPENGL);

    // create an event queue and register that window
    auto eventQueue = scoped!SDL2EventQueue(sdl2);
    eventQueue.registerWindow(window);

    // reload OpenGL now that a context exists
    gl.reload();

    double time = 0;
    while(!eventQueue.keyboard().isPressed(SDLK_ESCAPE))
    {
        eventQueue.processEvents();

        time += 0.10;

        // clear the whole window
        glViewport(0, 0, width, height);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        // load projection and model-view matrices
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrtho(-ratio, +ratio, -1.0, 1.0, -1.0, 1.0);

        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
        glRotatef(time * 10, 0, 0, 1);

        // draw a single triangle
        glBegin(GL_TRIANGLES);
            glColor3f(1.0f, 0.0f, 0.0f);
            glVertex2f(-0.5, -0.5);
            glColor3f(0.0f, 1.0f, 0.0f);
            glVertex2f(+0.5f, -0.5f);
            glColor3f(0.0f, 0.0f, 1.0f);
            glVertex2f(0.0f, 0.6f);
        glEnd();

        window.swapBuffers();
    }
}
