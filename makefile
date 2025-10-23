compiler = gcc
CFLAGS  = -Wall -fPIC -lsqlite3 $(INCLUDES)
INCLUDES = -I src/structs


#SERVIDOR
SERVER_SRCS = src/server-side/servidor-mq.c src/server-side/claves.c src/server-side/treat_sql.c
SERVER_OBJS = $(SERVER_SRCS:.c=.o)
SERVER_BIN  = servidor


#CLIENTE-libclaves
CLIENT_LIB_SRCS = src/client-side/proxy-mq.c
CLIENT_LIB_OBJS = $(CLIENT_LIB_SRCS:.c=.o)
LIB_NAME = src/client-side/libclaves.so

#CLIENTE CLIENTE1
CLIENT1_APP_SRCS = src/client-side/app-cliente.c
CLIENT1_APP_OBJS = $(CLIENT1_APP_SRCS:.c=.o)
CLIENT1_BIN = app-cliente

#CLIENTE CLIENTE2
CLIENT2_APP_SRCS =src/client-side/app-cliente2.c
CLIENT2_APP_OBJS = $(CLIENT2_APP_SRCS:.c=.o)
CLIENT2_BIN = app-cliente2

#CLIENTE CLIENTE3
CLIENT3_APP_SRCS =src/client-side/app-cliente3.c
CLIENT3_APP_OBJS = $(CLIENT3_APP_SRCS:.c=.o)
CLIENT3_BIN = app-cliente3


#CLIENTE CLIENTE INFINITO
CLIENT_INF_APP_SRCS =src/client-side/app-cliente-inf.c
CLIENT_INF_APP_OBJS = $(CLIENT_INF_APP_SRCS:.c=.o)
CLIENT_INF_BIN = app-cliente-infinito


#Regla para compilarlo todo
all: $(SERVER_BIN) $(LIB_NAME) $(CLIENT1_BIN) $(CLIENT2_BIN) $(CLIENT3_BIN) $(CLIENT_INF_BIN)


#COMPILACION SERVER
$(SERVER_BIN): $(SERVER_OBJS)
	$(compiler) -o $@ $(SERVER_OBJS) $(CFLAGS)

#COMPILACION DE LA LIBRERIA
$(LIB_NAME): $(CLIENT_LIB_OBJS)
	$(compiler) -shared -o $@ $(CLIENT_LIB_OBJS)

#CLIENTE1
$(CLIENT1_BIN): $(CLIENT1_APP_OBJS) $(LIB_NAME)
	$(compiler) -o $@ $(CLIENT1_APP_OBJS) $(LIB_NAME)

#CLIENTE2
$(CLIENT2_BIN): $(CLIENT2_APP_OBJS) $(LIB_NAME)
	$(compiler) -o $@ $(CLIENT2_APP_OBJS) $(LIB_NAME)

#CLIENTE3
$(CLIENT3_BIN): $(CLIENT3_APP_OBJS) $(LIB_NAME)
	$(compiler) -o $@ $(CLIENT3_APP_OBJS) $(LIB_NAME)

#CLIENTE-INFINITO
$(CLIENT_INF_BIN): $(CLIENT_INF_APP_OBJS) $(LIB_NAME)
	$(compiler) -o $@ $(CLIENT_INF_APP_OBJS) $(LIB_NAME)

#REGLA PARA CREAR LOS .o
%.o: %.c
	$(compiler) $(CFLAGS) -c $< -o $@

#LIMPIA; ME LO CARGO TODO
clean:
	rm -f $(SERVER_OBJS) $(CLIENT_LIB_OBJS) $(CLIENT1_APP_OBJS) $(CLIENT2_APP_OBJS) $(CLIENT3_APP_OBJS) \
			$(CLIENT_INF_APP_OBJS) \
	      $(SERVER_BIN) $(CLIENT1_BIN) $(CLIENT2_BIN) $(CLIENT3_BIN) $(CLIENT_INF_BIN) $(LIB_NAME)
	rm -r /tmp/database.db
