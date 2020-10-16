#include "Application.h"
#include <iostream>
// #include <GLFW/glfw3.h>
// specifying "GLFW" as part of path when we had already included immediate parent dir of glfw3.h, blocked MSVC from finding glfw3.h
// "cannot open source file GLFW/glfw3.h"
#include <GL/glew.h>
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

		const double viewSpace = 0.5;
		const double PI = 3.1415;
		const double delta = PI * 2 / 10;
		// TODO image does not scale with app size right now
		const double radius = viewSpace * 0.3;
		const double center = 0.0;
		const double triScale = 0.2;

		for (double theta = 0.0; theta < PI * 2; theta = theta + delta) {
			// start from points in a circle
			double yPos = center + radius * cos(theta);
			double xPos = center + radius * sin(theta);

			// compute dimensional offsets per each triangle
			// xOffset is a double-period function of theta
			double xOffset = triScale * cos(theta * 2.0);
			double yOffset = triScale * sin(theta * 2.0);

			glVertex2d(xPos + yOffset, yPos - xOffset);
			glVertex2d(xPos - yOffset, yPos + xOffset);
			glVertex2d(xPos - yOffset, yPos + 0.0);
		}

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
