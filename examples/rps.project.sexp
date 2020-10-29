(@module (begin end)
         (@label begin)
         (defdata Hand Rock Paper Scissors)
         (def tmp (λ (tag) (begin0 end0) (@label begin0) (def x (input Hand tag)) (return x) (@label end0)))
         (def tmp0
              (λ (x0)
                 (begin1 end1)
                 (@label begin1)
                 (@label begin-switch)
                 (switch x0 ((@app-ctor Rock) (return 0)) ((@app-ctor Paper) (return 1)) ((@app-ctor Scissors) (return 2)))
                 (@label end-switch)
                 (@label end1)))
         (def tmp1
              (λ (x1)
                 (begin2 end2)
                 (@label begin2)
                 (@label begin-switch0)
                 (switch x1 (0 (return Rock)) (1 (return Paper)) (2 (return Scissors)))
                 (@label end-switch0)
                 (@label end2)))
         (def Hand1 (@record (input tmp) (toNat tmp0) (ofNat tmp1)))
         (defdata Outcome B_Wins Draw A_Wins)
         (def tmp2 (λ (tag0) (begin3 end3) (@label begin3) (def x2 (input Outcome tag0)) (return x2) (@label end3)))
         (def tmp3
              (λ (x3)
                 (begin4 end4)
                 (@label begin4)
                 (@label begin-switch1)
                 (switch x3 ((@app-ctor B_Wins) (return 0)) ((@app-ctor Draw) (return 1)) ((@app-ctor A_Wins) (return 2)))
                 (@label end-switch1)
                 (@label end4)))
         (def tmp4
              (λ (x4)
                 (begin5 end5)
                 (@label begin5)
                 (@label begin-switch2)
                 (switch x4 (0 (return B_Wins)) (1 (return Draw)) (2 (return A_Wins)))
                 (@label end-switch2)
                 (@label end5)))
         (def Outcome1 (@record (input tmp2) (toNat tmp3) (ofNat tmp4)))
         (def winner
              (λ (handA handB)
                 (begin6 end6)
                 (@label begin6)
                 (def tmp5 (@dot Outcome1 ofNat))
                 (def tmp6 (@dot Hand1 toNat))
                 (def tmp7 (@app tmp6 handA))
                 (def tmp8 (@dot Hand1 toNat))
                 (def tmp9 (@app tmp8 handB))
                 (def tmp10 (@app - 4 tmp9))
                 (def tmp11 (@app + tmp7 tmp10))
                 (def tmp12 (@app mod tmp11 3))
                 (return (@app tmp5 tmp12))
                 (@label end6)))
         (def rockPaperScissors
              (@make-interaction
               ((@list A B))
               (wagerAmount)
               (begin7 end7)
               (#f
                (@label begin7)
                (@label cp)
                (consensus:set-participant A)
                (consensus:set-participant A)
                (consensus:set-participant A)
                (consensus:set-participant A)
                (consensus:set-participant A)
                (consensus:set-participant A)
                (def commitment (expect-published 'commitment))
                (consensus:set-participant A)
                (expect-deposited wagerAmount)
                (@label cp0)
                (consensus:set-participant B)
                (consensus:set-participant B)
                (consensus:set-participant B)
                (def handB0 (expect-published 'handB0))
                (consensus:set-participant B)
                (expect-deposited wagerAmount)
                (@label cp1)
                (consensus:set-participant A)
                (def salt (expect-published 'salt))
                (consensus:set-participant A)
                (def handA0 (expect-published 'handA0))
                (def tmp16 (@tuple salt handA0))
                (def tmp17 (digest tmp16))
                (def tmp18 (== commitment tmp17))
                (require! tmp18)
                (def outcome (@app winner handA0 handB0))
                (@label begin-switch3)
                (switch outcome
                        ((@app-ctor A_Wins) (def tmp19 (@app * 2 wagerAmount)) (expect-withdrawn A tmp19))
                        ((@app-ctor B_Wins) (def tmp20 (@app * 2 wagerAmount)) (expect-withdrawn B tmp20))
                        ((@app-ctor Draw) (expect-withdrawn A wagerAmount) (expect-withdrawn B wagerAmount)))
                (@label end-switch3)
                (return outcome)
                (@label end7))
               (A (@label begin7)
                  (@label cp)
                  (participant:set-participant A)
                  (def tmp13 (@dot Hand1 input))
                  (participant:set-participant A)
                  (def handA0 (@app tmp13 "First player, pick your hand"))
                  (participant:set-participant A)
                  (def salt (@app randomUInt256))
                  (participant:set-participant A)
                  (def tmp14 (@tuple salt handA0))
                  (participant:set-participant A)
                  (def commitment (digest tmp14))
                  (participant:set-participant A)
                  (add-to-publish 'commitment commitment)
                  (participant:set-participant A)
                  (add-to-deposit wagerAmount)
                  (@label cp0)
                  (participant:set-participant B)
                  (participant:set-participant B)
                  (participant:set-participant B)
                  (def handB0 (expect-published 'handB0))
                  (participant:set-participant B)
                  (expect-deposited wagerAmount)
                  (@label cp1)
                  (participant:set-participant A)
                  (add-to-publish 'salt salt)
                  (participant:set-participant A)
                  (add-to-publish 'handA0 handA0)
                  (def tmp16 (@tuple salt handA0))
                  (def tmp17 (digest tmp16))
                  (def tmp18 (== commitment tmp17))
                  (require! tmp18)
                  (def outcome (@app winner handA0 handB0))
                  (@label begin-switch3)
                  (switch outcome
                          ((@app-ctor A_Wins) (def tmp19 (@app * 2 wagerAmount)) (add-to-withdraw A tmp19))
                          ((@app-ctor B_Wins) (def tmp20 (@app * 2 wagerAmount)) (expect-withdrawn B tmp20))
                          ((@app-ctor Draw) (add-to-withdraw A wagerAmount) (expect-withdrawn B wagerAmount)))
                  (@label end-switch3)
                  (return outcome)
                  (@label end7))
               (B (@label begin7)
                  (@label cp)
                  (participant:set-participant A)
                  (participant:set-participant A)
                  (participant:set-participant A)
                  (participant:set-participant A)
                  (participant:set-participant A)
                  (participant:set-participant A)
                  (def commitment (expect-published 'commitment))
                  (participant:set-participant A)
                  (expect-deposited wagerAmount)
                  (@label cp0)
                  (participant:set-participant B)
                  (def tmp15 (@dot Hand1 input))
                  (participant:set-participant B)
                  (def handB0 (@app tmp15 "Second player, pick your hand"))
                  (participant:set-participant B)
                  (add-to-publish 'handB0 handB0)
                  (participant:set-participant B)
                  (add-to-deposit wagerAmount)
                  (@label cp1)
                  (participant:set-participant A)
                  (def salt (expect-published 'salt))
                  (participant:set-participant A)
                  (def handA0 (expect-published 'handA0))
                  (def tmp16 (@tuple salt handA0))
                  (def tmp17 (digest tmp16))
                  (def tmp18 (== commitment tmp17))
                  (require! tmp18)
                  (def outcome (@app winner handA0 handB0))
                  (@label begin-switch3)
                  (switch outcome
                          ((@app-ctor A_Wins) (def tmp19 (@app * 2 wagerAmount)) (expect-withdrawn A tmp19))
                          ((@app-ctor B_Wins) (def tmp20 (@app * 2 wagerAmount)) (add-to-withdraw B tmp20))
                          ((@app-ctor Draw) (expect-withdrawn A wagerAmount) (add-to-withdraw B wagerAmount)))
                  (@label end-switch3)
                  (return outcome)
                  (@label end7))))
         (return (@tuple))
         (@label end))
