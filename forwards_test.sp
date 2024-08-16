#pragma semicolon 1
#pragma newdecls required

#define MAX_FORWARDS 75 + 1
Handle Forwards[MAX_FORWARDS];

public Plugin myinfo = 
{
    name = "Test Forwards (Core)",
    author = "",
    description = "",
    version = "1.0",
    url = ""
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    RegPluginLibrary("forwards_test");

    for (int i = 1; i < MAX_FORWARDS; i++)
    {
        char forwardName[16];
        FormatEx(forwardName, sizeof(forwardName), "MyForward_%d", i);
        Forwards[i] = CreateGlobalForward(forwardName, ET_Event, Param_Cell);
    }

    return APLRes_Success;
}

public void OnPluginStart()
{
    RegAdminCmd("sm_bench", Command_Bench, ADMFLAG_ROOT, "Start/Stop benchmarking forwards");
}

public Action Command_Bench(int client, int args)
{
    CreateTimer(1.0, Timer_RunAllForwards);
    return Plugin_Handled;
}

public void OnPluginEnd()
{
    for (int i = 0; i < MAX_FORWARDS; i++)
    {
        if (Forwards[i] != INVALID_HANDLE)
            CloseHandle(Forwards[i]);
    }
}

public Action Timer_RunAllForwards(Handle timer)
{
    static int iCount = 1;
    LogMessage("Running all %d forwards %d times", MAX_FORWARDS - 1, iCount);

    float starttime = GetEngineTime();
    for (int i = 0; i < iCount; i++)
    {
        RunAllForwards();
    }

    float stoptime = GetEngineTime();
    LogMessage("Runned all %d forwards %d times (%d forward calls)", MAX_FORWARDS - 1, iCount, (MAX_FORWARDS - 1) * iCount);
    LogMessage("Running all forwards started at %f and ended at %f", starttime, stoptime);
    LogMessage("Total time: %f seconds", stoptime - starttime);

    if (iCount == 1)
        iCount = 0;
    iCount = iCount + 1000;

    return Plugin_Stop;
}

public void RunAllForwards()
{
    for (int i = 1; i < MAX_FORWARDS; i++)
    {
        int j = i;
        // Complex calculation involving multiple operations
        float baseValue = (j + 1) * 0.01 * i;
        float percentValue = baseValue * 0.15;  // Calculate 15% of baseValue
        float divisionValue = baseValue / (j + 1);  // Division
        float multiplicationValue = divisionValue * i;  // Multiplication
        float combinedValue = (percentValue + divisionValue) * multiplicationValue;
        PrintToChatAll("Value: %f", combinedValue);

        // Uncomment to fire forwards

        // if (Forwards[i] != INVALID_HANDLE)
        // {
        //     // Fire each forward with a test value
        //     Call_StartForward(Forwards[i]);
        //     Call_PushCell(i); // Example parameter
        //     Call_Finish();
        // }
    }
}
