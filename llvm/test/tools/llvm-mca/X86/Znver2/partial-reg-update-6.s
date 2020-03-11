# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver2 -iterations=1500 -timeline -timeline-max-iterations=4 < %s | FileCheck %s

# Each lzcnt has a false dependency on %ecx; the first lzcnt has to wait on the
# imul. However, the folded load can start immediately.
# The last lzcnt has a false dependency on %cx. However, even in this case, the
# folded load can start immediately.

imul %edx, %ecx
lzcnt (%rsp), %cx
lzcnt 2(%rsp), %cx

# CHECK:      Iterations:        1500
# CHECK-NEXT: Instructions:      4500
# CHECK-NEXT: Total Cycles:      9003
# CHECK-NEXT: Total uOps:        7500

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.83
# CHECK-NEXT: IPC:               0.50
# CHECK-NEXT: Block RThroughput: 1.3

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        imull	%edx, %ecx
# CHECK-NEXT:  2      5     0.33    *                   lzcntw	(%rsp), %cx
# CHECK-NEXT:  2      5     0.33    *                   lzcntw	2(%rsp), %cx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn2AGU0
# CHECK-NEXT: [1]   - Zn2AGU1
# CHECK-NEXT: [2]   - Zn2AGU2
# CHECK-NEXT: [3]   - Zn2ALU0
# CHECK-NEXT: [4]   - Zn2ALU1
# CHECK-NEXT: [5]   - Zn2ALU2
# CHECK-NEXT: [6]   - Zn2ALU3
# CHECK-NEXT: [7]   - Zn2Divider
# CHECK-NEXT: [8]   - Zn2FPU0
# CHECK-NEXT: [9]   - Zn2FPU1
# CHECK-NEXT: [10]  - Zn2FPU2
# CHECK-NEXT: [11]  - Zn2FPU3
# CHECK-NEXT: [12]  - Zn2Multiplier

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]
# CHECK-NEXT: 0.67   0.67   0.67   0.67   1.00   0.67   0.67    -      -      -      -      -     1.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   imull	%edx, %ecx
# CHECK-NEXT: 0.33   0.33   0.33   0.33    -     0.33   0.33    -      -      -      -      -      -     lzcntw	(%rsp), %cx
# CHECK-NEXT: 0.33   0.33   0.33   0.33    -     0.33   0.33    -      -      -      -      -      -     lzcntw	2(%rsp), %cx

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          0123456

# CHECK:      [0,0]     DeeeER    .    .    .    ..   imull	%edx, %ecx
# CHECK-NEXT: [0,1]     DeeeeeER  .    .    .    ..   lzcntw	(%rsp), %cx
# CHECK-NEXT: [0,2]     .DeeeeeER .    .    .    ..   lzcntw	2(%rsp), %cx
# CHECK-NEXT: [1,0]     .D=====eeeER   .    .    ..   imull	%edx, %ecx
# CHECK-NEXT: [1,1]     . D====eeeeeER .    .    ..   lzcntw	(%rsp), %cx
# CHECK-NEXT: [1,2]     . D=====eeeeeER.    .    ..   lzcntw	2(%rsp), %cx
# CHECK-NEXT: [2,0]     .  D=========eeeER  .    ..   imull	%edx, %ecx
# CHECK-NEXT: [2,1]     .  D=========eeeeeER.    ..   lzcntw	(%rsp), %cx
# CHECK-NEXT: [2,2]     .   D=========eeeeeER    ..   lzcntw	2(%rsp), %cx
# CHECK-NEXT: [3,0]     .   D==============eeeER ..   imull	%edx, %ecx
# CHECK-NEXT: [3,1]     .    D=============eeeeeER.   lzcntw	(%rsp), %cx
# CHECK-NEXT: [3,2]     .    D==============eeeeeER   lzcntw	2(%rsp), %cx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     4     8.0    0.3    0.0       imull	%edx, %ecx
# CHECK-NEXT: 1.     4     7.5    0.0    0.0       lzcntw	(%rsp), %cx
# CHECK-NEXT: 2.     4     8.0    0.0    0.0       lzcntw	2(%rsp), %cx
# CHECK-NEXT:        4     7.8    0.1    0.0       <total>
