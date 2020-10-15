#include "Application.h"
#include <iostream>
// #include <GLFW/glfw3.h>
// specifying "GLFW" as part of path when we had already included immediate parent dir of glfw3.h, blocked MSVC from finding glfw3.h
// "cannot open source file GLFW/glfw3.h"
#include <glfw3.h>

int main(void)
{
	std::cout << "Hello world. this is a test of C++ and GLFW" << std::endl;
	std::cin.get();

	// code from https://www.glfw.org/documentation.html

	// follow along with https://www.youtube.com/watch?v=OR4fNpBjmq8
	// TODO convert from default OpenGL 1.1 / Win default API, to OpenGL

	GLFWwindow* window;

	/* Initialize the library */
	if (!glfwInit())
		return -1;

	/* Create a windowed mode window and its OpenGL context */
	window = glfwCreateWindow(640, 480, "Hello World", NULL, NULL);
	if (!window)
	{
		glfwTerminate();
		return -1;
	}

	/* Make the window's context current */
	glfwMakeContextCurrent(window);

	/* Loop until the user closes the window */
	while (!glfwWindowShouldClose(window))
	{
		/* Render here */
		glClear(GL_COLOR_BUFFER_BIT);

		glBegin(GL_TRIANGLES);

		glVertex2f(-0.5f, -0.5f);
		glVertex2f(0.5f, -0.5f);
		glVertex2f(0.0f, 0.5f);

		glEnd();

		/* Swap front and back buffers */
		glfwSwapBuffers(window);

		/* Poll for and process events */
		glfwPollEvents();
	}

	glfwTerminate();
	return 0;
}

Application::Application()
{
}


Application::~Application()
{
}
