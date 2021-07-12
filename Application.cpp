#include "Application.h"
#include <iostream>
// #include <GLFW/glfw3.h>
// specifying "GLFW" as part of path when we had already included immediate parent dir of glfw3.h, blocked MSVC from finding glfw3.h
// "cannot open source file GLFW/glfw3.h"
#include <GL/glew.h>
#include <glfw3.h>

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

static unsigned int CompileShader(unsigned int type, const std::string& source) {
	unsigned int id = glCreateShader(type);
	// ensure that when we call ($string).c_str(), the value in ($string) will never have been garbage collected
	const char* src = source.c_str();
	// nullptr = auto-calculate length
	glShaderSource(id, 1, &src, nullptr);
	glCompileShader(id);

	int result;
	glGetShaderiv(id, GL_COMPILE_STATUS, &result);
	if (result == GL_FALSE) {
		int length;
		glGetShaderiv(id, GL_INFO_LOG_LENGTH, &length);
		char* message = (char*)alloca(length * sizeof(char));
		glGetShaderInfoLog(id, length, &length, message);

		std::cout << "Failed to compile shader!" << message << std::endl;
		glDeleteShader(id);
		return 0;
	}

	return id;
}

static unsigned int CreateShader(const std::string& vertexShaderString, const std::string& fragmentShaderString) {
	unsigned int shaderProgram = glCreateProgram();
	unsigned int vs = CompileShader(GL_VERTEX_SHADER, vertexShaderString);
	unsigned int fs = CompileShader(GL_FRAGMENT_SHADER, fragmentShaderString);

	glAttachShader(shaderProgram, vs);
	glAttachShader(shaderProgram, fs);
	glLinkProgram(shaderProgram);
	glValidateProgram(shaderProgram);
	
	// vert and frag shaders linked in shaderProgram; we can now destroy these resources
	glDeleteShader(vs);
	glDeleteShader(fs);

	return shaderProgram;
}

static const::std::string getStringFromFile(const::std::string& filepath) {
	std::ifstream stream(filepath);
	std::string line;
	std::stringstream ss;

	while (getline(stream, line)) {
		ss << line << '\n';
	}

	return ss.str();
}

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
	float positions[6] = {
		-1.0f, -1.0f, 
		0.0f, 1.0f, 
		1.0f, -1.0f
	};

	unsigned int buffer;
	glGenBuffers(1, &buffer);
	glBindBuffer(GL_ARRAY_BUFFER, buffer);
	glBufferData(GL_ARRAY_BUFFER, xyPairCount * xyCount * sizeof(float), positions, GL_STATIC_DRAW);

	// enable the future attrib array
	glEnableVertexAttribArray(0);
	// pass a vertex data collection. in our case we are passing in a collection of floats 
	// and instructing GL to parse them as a series of float params of a collection of vertices
	glVertexAttribPointer(0, xyCount, GL_FLOAT, GL_FALSE, sizeof(float) * xyCount, 0);

	// load vert shader from local .shader file
	std::string vertexShaderString = getStringFromFile("res/Shaders/BasicVertexShader.shader");
	// load frag shader from local .shader file
	std::string fragmentShaderString = getStringFromFile("res/Shaders/BasicFragmentShader.shader");

	unsigned int shader = CreateShader(vertexShaderString, fragmentShaderString);
	glUseProgram(shader);

	/* Loop until the user closes the window */
	while (!glfwWindowShouldClose(window))
	{
		/* Render here */
		glClear(GL_COLOR_BUFFER_BIT);

		glDrawArrays(GL_TRIANGLES, 0, xyPairCount);

		/* Swap front and back buffers */
		glfwSwapBuffers(window);

		/* Poll for and process events */
		glfwPollEvents();
	}

	glDeleteProgram(shader);

	glfwTerminate();
	return 0;
}

Application::Application()
{
}


Application::~Application()
{
}
