#define MAX_NICKNAMES 6


// paramters for command buffer stuffing
typedef enum {
	EXEC_NOW,			// don't return until completed, a VM should NEVER use this,
						// because some commands might cause the VM to be unloaded...
	EXEC_INSERT,		// insert at current position, but don't run yet
	EXEC_APPEND			// add to end of the command buffer (normal case)
} cbufExec_t;

#define MAX_CMD_BUFFER  16384
#define MAX_CMD_LINE    1024
/*
typedef struct {
	byte    *data;
	int maxsize;
	int cursize;
} cmd_t;

int cmd_wait;
cmd_t cmd_text;
byte cmd_text_buf[MAX_CMD_BUFFER];
*/

typedef void *xcommand_t;

typedef struct cmd_function_s
{
	struct cmd_function_s   *next;
	char                    *name;
	int			minPower;
	completionFunc_t	complete;
	xcommand_t function;
} cmd_function_t;


//static int cmd_argc;
//static char        *cmd_argv[MAX_STRING_TOKENS];        // points into cmd_tokenized
//static char cmd_tokenized[BIG_INFO_STRING + MAX_STRING_TOKENS];         // will have 0 bytes inserted
//static char cmd_cmd[BIG_INFO_STRING];         // the original command we received (no token processing)

#define cmd_functions (cmd_function_t*)*((int*)(0x887eb98))
//static cmd_function_t  *cmd_functions;      // possible commands to execute
#define MAX_POWERLIST 256
