
DefinitionBlock ("", "SSDT", 1, "hack", "XE42", 0x00000000)
{    External (_GPE.DMSI, MethodObj)    // 0 Arguments (from opcode)
    External (_GPE.GNIS, MethodObj)    // 0 Arguments (from opcode)
    External (_GPE.NTFY, MethodObj)    // 0 Arguments (from opcode)
    External (_GPE.PGWA, MethodObj)    // 0 Arguments (from opcode)
    External (_GPE.RSMI, MethodObj)    // 0 Arguments (from opcode)
    External (_GPE.TBFF, MethodObj)    // 0 Arguments (from opcode)
    External (_GPE.WSUB, MethodObj)    // 0 Arguments (from opcode)
    External (_GPE.WWAK, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.CAGS, MethodObj)    // 1 Arguments (from opcode)
    External (ADBG, MethodObj)    // 1 Arguments (from opcode)
    External (CF2T, FieldUnitObj)    // (from opcode)
    External (CPGN, FieldUnitObj)    // (from opcode)
    External (DMSI, IntObj)    // Warning: Unknown object
    External (DPTF, FieldUnitObj)    // (from opcode)
    External (GNIS, IntObj)    // (from opcode)
    External (NTFY, MethodObj)    // Warning: Unknown method, guessing 0 arguments
    External (OSUM, MutexObj)    // (from opcode)
    External (P8XH, MethodObj)    // 2 Arguments (from opcode)
    External (PGWA, MethodObj)    // Warning: Unknown method, guessing 0 arguments
    External (RSMI, IntObj)    // (from opcode)
    External (SOHP, FieldUnitObj)    // (from opcode)
    External (TBFF, IntObj)    // (from opcode)
    External (TBSW, FieldUnitObj)    // (from opcode)
    External (TNAT, FieldUnitObj)    // (from opcode)
    External (WSUB, MethodObj)    // Warning: Unknown method, guessing 0 arguments
    External (WWAK, MethodObj)    // Warning: Unknown method, guessing 1 arguments

    Scope (\_GPE)
    {
        Method (XE42, 0, NotSerialized)
        {
            ADBG ("_E42")
            If (LEqual (CF2T, One))
            {
                ADBG ("Clear")
                ADBG ("GPI_GPE_STS")
                \_SB.CAGS (CPGN)
            }

            WWAK ()
            WSUB ()
            If (LEqual (TNAT, One))
            {
                Store (RSMI (), Local0)
                If (LNot (Local0))
                {
                    Return (Zero)
                }

                If (DMSI ())
                {
                    Return (Zero)
                }
            }

            If (GNIS ())
            {
                Return (Zero)
            }

            OperationRegion (SPRT, SystemIO, 0xB2, 0x02)
            Field (SPRT, ByteAcc, Lock, Preserve)
            {
                SSMP,   8
            }

            ADBG ("TBT-HP-Handler")
            ADBG ("PEG WorkAround")
            PGWA ()
            Acquire (OSUM, 0xFFFF)
            Store (TBFF (), Local1)
            If (LEqual (Local1, One))
            {
                Sleep (0x10)
                Release (OSUM)
                ADBG ("OS_Up_Received")
                If (LEqual (DPTF, One))
                {
                    Return (Zero)
                }

                Return (Zero)
            }

            If (LEqual (Local1, 0x02))
            {
                NTFY ()
                Sleep (0x10)
                Release (OSUM)
                P8XH (Zero, 0x7D)
                ADBG ("Disconnect")
                Return (Zero)
            }

            If (LEqual (SOHP, One))
            {
                ADBG ("TBT SW SMI")
                Store (TBSW, SSMP)
            }

            NTFY ()
            Sleep (0x10)
            Release (OSUM)
            ADBG ("End-of-_E42")
        }
    }
}

