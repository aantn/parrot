
/* Types */

enum INSTYPE {    /*instruction type can be   */
    ITBRANCH = 0x10000, /*            branch        */
    ITOP =     0x20000, /*            normal op     */
    ITCALL =   0x40000, /*            function call */
    ITLABEL =  0x80000, /*            label         */
    ITALIAS = 0x100000, /*   set P,P  */
    ITADDR  = 0x200000, /*   set_addr P, addr*/
    ITSPILL = 0x400000  /*   set P31,x ; set x, p31 spilling */
};


typedef struct _Instruction {
    char * op;		/* opstring w/o params */
    char * fmt;            /* printf style format string for params   */
    SymReg * r[IMCC_MAX_REGS];  /*   uses {r0-rx}->reg     */
    unsigned int flags;            /* how the instruction affects each of the values */
    unsigned int type;	   /* 16 bit register branches, + ITxxx */
    int keys;		/* bitmask of keys used in this ins */
    int index;             /* index on instructions[] */
    int bbindex;	   /* nr of bb, where ins is in */
    struct _Instruction * prev;
    struct _Instruction * next;
    int opnum;		/* parrot op #*/
    int opsize;		/* parrot op size */
} Instruction;


/* XXX fix flags [bitmap]
 * int flags_r
 * int flags_w
 * int flags_jump
 */
typedef enum {
    /* Indicate how the instruction affects each of the register */
    IF_r0_read  = (1 << 0),
    IF_r1_read  = (1 << 1),
    IF_r2_read  = (1 << 2),
    IF_r3_read  = (1 << 3),
    /* .... */
    IF_r0_write = (1 << 16),
    IF_r1_write = (1 << 17),
    IF_r2_write = (1 << 18),
    IF_r3_write = (1 << 19),
    /* .... */
    IF_binary  = (IF_r0_write|IF_r1_read|IF_r2_read), /* templ for binary op */
    IF_unary   = (IF_r0_write|IF_r1_read),           /* templ for unary  op */
    IF_inplace = (IF_r0_write|IF_r0_read),    /* templ for inplace unary  op */
    /* the branch flags are the lowe 16 bits of type
     * for uperr 16 see ITXX above */
    IF_r0_branch  = (1 << 0),
    IF_r1_branch  = (1 << 1),
    IF_r2_branch  = (1 << 2),
    IF_goto =       (1 << 15),
} Instruction_Flags;



/* Functions */
/*
 * _mk_instruction is not intended for outside usage
 * please use iANY
 */
#ifdef _PARSER
Instruction * _mk_instruction(const char *,const char *, SymReg **, int);
#else
#define _mk_instruction(a,b,c,d) dont_use(a,b)
#endif
Instruction * iANY(char * name, char *fmt, SymReg **r, int emit);
Instruction * INS(char * name, char *fmt, SymReg **regs, int nargs, int keyv);
Instruction * iNEW(SymReg * r0, char * type, int emit);
Instruction * emitb(Instruction *);
int instruction_reads(Instruction *, SymReg *);
int instruction_writes(Instruction *, SymReg *);
void compute_spilling_costs();
void free_ins(Instruction *);
char * ins_string(Instruction * ins);

Instruction *delete_ins(Instruction *ins, int free);
void insert_ins(Instruction *ins, Instruction * tmp);
Instruction *move_ins(Instruction *cur, Instruction *to);

int get_branch_regno(Instruction * ins);
SymReg *get_branch_reg(Instruction * ins);

/* Globals */

EXTERN Instruction* instructions;

typedef struct _emittert {
	int (*open)(char *file);
	int (*emit)(Instruction *ins);
	int (*close)(void);
} Emitter;

enum Emitter_type { EMIT_FILE, EMIT_PBC };

int emit_open(int type, char *file);
int emit_flush();
int emit_close();

