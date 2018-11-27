
DefinitionBlock ("", "SSDT", 1, "syscl", "ARPT", 0x00003000)
{
    External (_SB_.PCI0.RP05, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.RP05.PXSX, DeviceObj)    // (from opcode)
    External (PXSX, DeviceObj)    // (from opcode)

    Scope (\_SB.PCI0.RP05)
    {
        Method (_DSM, 4, NotSerialized)
        {
	        If (LEqual (Arg2, Zero))
	        {
		        Return (Buffer (One){0x03})
	        }
	        Return (Package (0x02)
	        {
	        	"reg-ltrovr", 
	        	Buffer (0x08)
	        	{
		        	0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
		        }
	        })
        }
        
        Scope (PXSX)
        {
            Name (_STA, Zero)  // _STA: Status
        }

        Device (ARPT)
        {
            Name (_ADR, Zero)  // _ADR: Address
            /*
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x09, 
                0x04
            })*/
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (LEqual (Arg2, Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                           
                    })
                }

                Return (Package (0x02)
                {
                    "reg-ltrovr", 
                    Buffer (0x08)
                    {
                         0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
                    }
                })
            }
        }
    }

    Store ("SSDT-ARPT-RP05 github.com/syscl", Debug)
}

