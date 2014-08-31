//PunkBuster Status list
typedef enum {
    PRE,
    INIT,
    UPD,
    OK,
    SPEC,
    SBOT,
    UNK
} pbstatus_t;

typedef struct {
int		*saptr;
int		savesa;
char		*execmemaddr;
int		hwid;
int		guid;
int		status;
int		OS;
void*		pbsvhandle;
void*		pbsvbase;
int		playermemsize;
} pbsventrypoints_t;

typedef struct {
char*		hwid;
char*		guid;
pbstatus_t	status;
char*		OS;
} pbsvplayerinfo_t;

static	pbsventrypoints_t	pbsvaddr;
static	qboolean		ptrofpofmade = qfalse;
static	void*			playeroffsetfunc = NULL;

#define pbsvaddrsa = (int*)(0x8879820+0x150)
