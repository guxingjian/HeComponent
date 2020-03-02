//
//  Heqz_CrashCatcher.m
//  HeComponent
//
//  Created by qingzhao on 2019/5/24.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqz_CrashCatcher.h"
#include <execinfo.h>

@interface Heqz_CrashCatcher()

@property(nonatomic, assign)BOOL bStatus;
- (void)catchSignalStackInfo:(NSString*)strInfo;

@end

static Heqz_CrashCatcher* catcher = nil;

static NSUncaughtExceptionHandler *previousUncaughtExceptionHandler;

typedef void (*SignalHandler)(int signo, siginfo_t *info, void *context);
static int s_fatal_signals[] = {
    SIGHUP,
    SIGINT,
    SIGQUIT,
    SIGILL,
    SIGTRAP,
    SIGABRT,
    SIGIOT,
    SIGEMT,
    SIGFPE,
    SIGKILL,
    SIGBUS,
    SIGSEGV,
    SIGSYS,
    SIGPIPE,
    SIGALRM,
    SIGTERM,
    SIGURG,
    SIGSTOP,
    SIGTSTP,
    SIGCONT,
    SIGCHLD,
    SIGTTIN,
    SIGTTOU
};
static const char* s_fatal_signal_names[] = {
    "SIGHUP",
    "SIGINT",
    "SIGQUIT",
    "SIGILL",
    "SIGTRAP",
    "SIGABRT",
    "SIGIOT",
    "SIGEMT",
    "SIGFPE",
    "SIGKILL",
    "SIGBUS",
    "SIGSEGV",
    "SIGSYS",
    "SIGPIPE",
    "SIGALRM",
    "SIGTERM",
    "SIGURG",
    "SIGSTOP",
    "SIGTSTP",
    "SIGCONT",
    "SIGCHLD",
    "SIGTTIN",
    "SIGTTOU"
};

static int s_fatal_signal_num = sizeof(s_fatal_signals) / sizeof(s_fatal_signals[0]);
static SignalHandler* oldHandlerBuffer;

void LDAPMClearSignalRigister(){
    for(NSInteger i = 0; i < s_fatal_signal_num; ++ i){
        int sig = s_fatal_signals[i];
        struct sigaction action;
        action.sa_sigaction = 0;
        sigaction(sig, &action, 0);
    }
    free(oldHandlerBuffer);
}

static void LDAPMSignalHandler(int signal, siginfo_t* info, void* context) {
    int nIndex = -1;
    for(int i = 0; i < s_fatal_signal_num; ++ i){
        int sig = s_fatal_signals[i];
        if(sig == signal){
            nIndex = i;
            break;
        }
    }
    if(nIndex < 0)
        return ;
    
    //  获取堆栈，收集堆栈
    NSString* sigName = [NSString stringWithUTF8String:s_fatal_signal_names[nIndex]];
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:[NSString stringWithFormat:@"Signal:%@\n",sigName]];
    [mstr appendString:@"Stack:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    [catcher catchSignalStackInfo:mstr];
    
    LDAPMClearSignalRigister();
    // 处理前者注册的 handler
    
    SignalHandler oldHandler = oldHandlerBuffer[nIndex];
    oldHandler(signal, info, context);
}

static void LDAPMSignalRegister(int signal) {
    struct sigaction action;
    action.sa_sigaction = LDAPMSignalHandler;
    action.sa_flags = SA_NODEFER | SA_SIGINFO;
    sigemptyset(&action.sa_mask);
    sigaction(signal, &action, 0);
}

static void installSignalHandler(){
    for(NSInteger i = 0; i < s_fatal_signal_num; ++ i){
        int sig = s_fatal_signals[i];
        struct sigaction old_action;
        sigaction(sig, NULL, &old_action);
        if (old_action.sa_flags & SA_SIGINFO) {
            oldHandlerBuffer[i] = old_action.sa_sigaction;
        }
        LDAPMSignalRegister(sig);
    }
}

static void LDAPMUncaughtExceptionHandler(NSException *exception) {
    // 获取堆栈，收集堆栈
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",reason , name, stackArray];
    [catcher catchSignalStackInfo:exceptionInfo];
    //  处理前者注册的 handler
    if (previousUncaughtExceptionHandler) {
        previousUncaughtExceptionHandler(exception);
    }
}

@implementation Heqz_CrashCatcher

+ (instancetype)sharedCrashCatcher{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        catcher = [[self alloc] init];
    });
    return catcher;
}

- (void)startCrashCatcher{
    oldHandlerBuffer = malloc(sizeof(SignalHandler)*s_fatal_signal_num);
    installSignalHandler();
    previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&LDAPMUncaughtExceptionHandler);
}

- (void)catchSignalStackInfo:(NSString*)strInfo{
    if([self.delegate respondsToSelector:@selector(crashCatcherDidCatchInfo:)]){
        [self.delegate crashCatcherDidCatchInfo:strInfo];
    }
}

@end
