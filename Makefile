###################################################################
########  Author    : yuliang
########  Date      : 2019-02-19
######## Description: 用于图像采集驱动相关测试
########  Notes     ：
########              1. 根据场合，选择不同的编译器，
########              2. EMBED_PLATFORM, 用于嵌入式平台，否则用于PC机
########              4. jpeg解码采用 libjpeg库，也要源码包，根据编译器编译，
########                 或者只是 jpeg格式解析，则直接用 jidct
########              5. 根据不同平台，替换不同的 videodev2.h
###################################################################

Version=0.2.0
PREX_CC=arm-linux-gnueabihf-

C=gcc
G=g++
CFLAGS = -Wall -O3 -g -std=gnu99  -DDEBUG_ON  $(INCLUDE)  -DVERSION=\"$(Version)\"   -DEMBED_PLATFORM  -mfloat-abi=hard  -mfpu=neon -ffast-math -march=armv7-a  -mtune=cortex-a9 

CPPFLAGS = -Wall -O -g -DVERSION=\"$(Version)\"
LDFLAGS = -lm  -I./jpeg-9c/.libs 
INCLUDE= -I./  -I./x264  -I./libdmtx-0.7.4  -I./jpeg-9c/  -I./uvcGadget/
TARGET =./test 

%.o:%.c 
	@echo \# Compiling $< 
	$(PREX_CC)$(C)  $(INCLUDE)  $(CFLAGS) -c $< -o $@  
	  
%.o:%.cpp 
	$(PREX_CC)$(G)  $(INCLUDE)  $(CPPFLAGS) -c $< -o $@  
		  
SOURCES = $(wildcard *.c *.cpp) 
OBJS = $(patsubst %.c,%.o, $(patsubst %.cpp,%.o,$(SOURCES))) 

$(TARGET):$(OBJS)
	@echo \# 	
	@echo \# Linking
	$(PREX_CC)$(C)  $(INCLUDE) $(OBJS) $(LDFLAGS) -lpthread  -O3 -o $(TARGET)
	@echo \# Final executable $(TARGET) create OK !!!	
	@echo \# 
	chmod +x $(TARGET)
	@echo \# 

clean:
	rm -rf *.o $(TARGET)


