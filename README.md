프로그램 설명
===========
이 프로그램은  정보과학회 학회지 논문인 Haskell을 이용한 병렬 프로그래밍에서 사용된 예제 코드입니다.

#0. 사전 설치 프로그램
## 0.1 컴파일러 설치 (https://www.haskell.org/downloads 참조)
- GHC
- Cabal
- Stack

## 0.2 필요 라이브러리 설치
- parallel (cabal install parallel)

#1. Eval 모나드 프로그램
##1.1 피보나치 수열
###1.1.1 피보나치 수열 빌드 방법
- fibo 폴더를 다운로드 합니다.
- cd fibo
- ghc -O2 -threaded -rtsopts -o fibo Main.hs
###1.1.2 피보나치 수열 실행 방법
- 싱글 프로그램 실행 : ./fibo seq
- 병렬 프로그램 실행 : ./fibo par +RTS -N4 (-N 뒤의 숫자는 CPU의 코어 수)
##1.2 리만 제타 함수
###1.2.1 리만 제타 함수 빌드 방법
- zeta 폴더를 다운로드 합니다.
- cd zeta
- ghc -O2 -threaded -rtsopts -o zeta Zeta.hs
###1.2.2 리만 제타 함수 실행 방법
- 주의 사항 : 첫 번째 인자는 CPU 코어 수와 동일하게 지정, 계산 전략은 rdeepseq, rpar, rseq만 입력 가능
- ./zeta 4 50000000 1:+1 rdeepseq +RTS -N4

#2. MVar를 이용한 동시성 프로그램
##2.1 식사하는 철학자들
###2.1.1 식사하는 철학자들 빌드 방법
- philosopher 폴더를 다운로드 합니다.
- cd philosopher
- ghc -O2 -threaded -rtsopts -o ph Philosopher.hs
###2.1.2 식사하는 철학자들 실행 방법
- ./ph +RTS -N4

#3. Cloud Haskell을 이용한 분산 환경 프로그램
##3.1 피보나치 수열의 합
###3.1.1 피보나치 수열의 합 빌드 방법
- CloudHaskellFibo 폴더를 다운로드 합니다.
- cd CloudHaskellFibo
- stack build
###3.1.2 피보나치 수열의 합 실행 방법
- 주의 사항 : 슬레이브 노드부터 실행해야 됨
- 마스터 노드 : stack exec CloudHaskellFibo-exe master 127.0.0.1 80 40
- 슬레이브 노드 : stack exec CloudHaskellFibo-exe slave 127.0.0.1 81
