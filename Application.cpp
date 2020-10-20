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

	if (glewInit() != GLEW_OK) {
		std::cout << "Error in initializing GLEW!" << std::endl;
	}

	std::cout << "GL version: " << glGetString(GL_VERSION) << std::endl;

	// how many elements in a 2-element vector? 2!
	const unsigned int xyCount = 2;
	// how many 2-element vectors we have
	const unsigned int xyPairCount = 3;
	float positions[6] = {-0.5f, -0.5f, 0.0f, 0.5f, 0.5f, -0.5f};

	unsigned int buffer;
	glGenBuffers(1, &buffer);
	glBindBuffer(GL_ARRAY_BUFFER, buffer);

	// enable the future attrib array
	glEnableVertexAttribArray(0);
	// pass a vertex data collection. in our case we are passing in a collection of floats 
	// and instructing GL to parse them as a series of float params of a collection of vertices
	glVertexAttribPointer(0, sizeof(float) * xyCount, GL_FLOAT, GL_FALSE, xyCount * sizeof(float), 0);

	glBufferData(GL_ARRAY_BUFFER, xyCount * xyPairCount * sizeof(float), &buffer, GL_STATIC_DRAW);

	/* Loop until the user closes the window */
	while (!glfwWindowShouldClose(window))
	{
		/* Render here */
		glClear(GL_COLOR_BUFFER_BIT);

		glBegin(GL_TRIANGLES);

		glDrawArrays(GL_TRIANGLES, 0, sizeof(float) * xyPairCount);

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
