# Shader compile utils
function(GET_SHADER_TYPE IN_TYPE OUT_TYPE)
	if("${IN_TYPE}" STREQUAL "vert")
		set(${OUT_TYPE} "vertex" PARENT_SCOPE)
	elseif("${IN_TYPE}" STREQUAL "frag")
		set(${OUT_TYPE} "fragment" PARENT_SCOPE)
	elseif("${IN_TYPE}" STREQUAL "geom")
		set(${OUT_TYPE} "geometry" PARENT_SCOPE)
	else()
		message(FATAL_ERROR "Shader type ${IN_TYPE} to handle")
	endif()
endfunction()

function(GET_SHADER_INFOS FILENAME OUT_SHADER_NAME OUT_SHADER_TYPE OUT_BIN_SHADER_NAME OUT_OK)
	if(${FILENAME} MATCHES "^([a-zA-Z0-9_]+).(vert|frag|tesc|tesv|geom|comp).glsl$")
		get_shader_type(${CMAKE_MATCH_2} SHADER_TYPE)
		set(${OUT_SHADER_NAME} ${CMAKE_MATCH_1} PARENT_SCOPE)
		set(${OUT_SHADER_TYPE} ${SHADER_TYPE} PARENT_SCOPE)
		set(${OUT_BIN_SHADER_NAME} ${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.spv PARENT_SCOPE)
		set(${OUT_OK} True PARENT_SCOPE)
	else()
		message(WARNING "${FILENAME} is not a compatible name")
		set(${OUT_OK} False PARENT_SCOPE)
	endif()
endfunction(GET_SHADER_INFOS)

function(COMPILE_SHADER SHADER SHADER_SRC_DIR SHADER_BIN_DIR OUT_SHADER)
	get_shader_infos(${SHADER} SHADER_NAME SHADER_TYPE BIN_SHADER_NAME OK)
	if(OK)
		set(SHADER_IN ${SHADER_SRC_DIR}/${SHADER})
		set(SHADER_OUT ${SHADER_BIN_DIR}/${BIN_SHADER_NAME})
		add_custom_command(
			OUTPUT
				${SHADER_OUT}
			COMMAND
				glslc -fshader-stage=${SHADER_TYPE} ${SHADER_SRC_DIR}/${SHADER} -o ${SHADER_OUT}
			MAIN_DEPENDENCY
				${SHADER_IN}
			COMMENT
				"Compiling ${SHADER_IN} to ${SHADER_OUT}"
		)

		set(${OUT_SHADER} ${SHADER_OUT} PARENT_SCOPE)
	endif()
endfunction(COMPILE_SHADER)
