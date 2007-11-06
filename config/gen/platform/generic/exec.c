/*
 * $Id$
 * Copyright (C) 2004-2007, The Perl Foundation.
 */

/*

=head1 NAME

config/gen/platform/generic/exec.c

=head1 DESCRIPTION

system() stuff

=head2 Functions

=over 4

=cut

*/

#include <sys/types.h>
#include <sys/wait.h>

/*

=item C<INTVAL
Parrot_Run_OS_Command(Parrot_Interp interp, STRING *command)>

Spawn off a subprocess and wait for the damn thing to complete,
returning the return value of the process

=cut

*/

INTVAL
Parrot_Run_OS_Command(Parrot_Interp interp, STRING *command)
{
    pid_t child;
    child = fork();
    /* Did we fail? */
    if (-1 == child) {
        real_exception(interp, NULL, NOSPAWN, "Can't spawn child process");
    }
    /* Are we the parent or child? */
    if (child) {
        /* parent */
        int status;
        pid_t returnstat;
        returnstat = waitpid(child, &status, 0);
        UNUSED(returnstat);
        return status;
    }
    else {
        /* child. Be horribly profligate with memory, since we're
           about to be something else */
        int status;
        status = execlp("sh", "sh", "-c",
            string_to_cstring(interp, command), (void *)NULL);
        /* if we get here, something's horribly wrong... */
        if (status) {
            exit(status);
        }
    }
    return 1;    /* make gcc happy */
}

/*

=item C<INTVAL
Parrot_Run_OS_Command_Argv(Parrot_Interp interp, PMC *cmdargs)>

TODO: Not yet documented!!!

=cut

*/

INTVAL
Parrot_Run_OS_Command_Argv(Parrot_Interp interp, PMC *cmdargs)
{
    pid_t child;
    int len = VTABLE_elements(interp, cmdargs);
    if (len == 0) {
        real_exception(interp, NULL, NOSPAWN, "Empty argument array for execvp");
    }
    child = fork();
    /* Did we fail? */
    if (-1 == child) {
        real_exception(interp, NULL, NOSPAWN, "Can't spawn child process");
    }
    /* Are we the parent or child? */
    if (child) {
        /* parent */
        int status;
        pid_t returnstat;
        returnstat = waitpid(child, &status, 0);
        UNUSED(returnstat);
        return status;
    }
    else {
        /* child. Be horribly profligate with memory, since we're
           about to be something else */
        int status, i;
        char **argv;
        STRING *s;
        char *cmd;

        argv = (char **)mem_sys_allocate((len+1)*sizeof (char *));
        for (i = 0; i < len; ++i) {
            s = VTABLE_get_string_keyed_int(interp, cmdargs, i);
            argv[i] = string_to_cstring(interp, s);
        }
        cmd = argv[0];
        argv[i] = NULL;

        status = execvp(cmd, argv);
        /* if we get here, something's horribly wrong... */
        if (status) {
            exit(status);
        }
    }
    return 1;    /* make gcc happy */
}

/*

=item C<void
Parrot_Exec_OS_Command(Parrot_Interp interp, STRING *command)>

TODO: Not yet documented!!!

=cut

*/

void
Parrot_Exec_OS_Command(Parrot_Interp interp, STRING *command)
{
    /* Be horribly profligate with memory, since we're
       about to be something else */
    int status;
    status = execlp("sh", "sh", "-c",
            string_to_cstring(interp, command), (void *)NULL);
    /* if we get here, something's horribly wrong... */
    if (status) {
        real_exception(interp, NULL, NOSPAWN, "Exec failed, code %i", status);
    }
}

/*
 * Local variables:
 *   c-file-style: "parrot"
 * End:
 * vim: expandtab shiftwidth=4:
 */
