AUTOMAKE_OPTIONS = foreign
bin_PROGRAMS = funca_program
funca_program_SOURCES = main.cpp funca.cpp funca.h
funca_program_CXXFLAGS = -fno-lto
EXTRA_DIST = Makefile.am


TESTS = test_funca
check_PROGRAMS = test_funca
tests_test_funca_SOURCES = test_funca.cpp funca.cpp funca.h
