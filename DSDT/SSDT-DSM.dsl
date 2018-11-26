
DefinitionBlock ("", "SSDT", 2, "hack", "DSM", 0x00000000)
{
    
    //RP01 -> SSDT-XHC.dsl / SSDT-TYPC.dsl

    External (_SB.PCI0.RP02, DeviceObj)
    Scope (_SB.PCI0.RP02)
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
    }

    External (_SB.PCI0.RP03, DeviceObj)
    Scope (_SB.PCI0.RP03)
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
    }

    External (_SB.PCI0.RP04, DeviceObj)
    Scope (_SB.PCI0.RP04)
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
    }
    
    
    //RP05 -> SSDT-PXSX2ARPT.dsl

    External (_SB.PCI0.RP06, DeviceObj)
    Scope (_SB.PCI0.RP06)
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
    }

    External (_SB.PCI0.RP07, DeviceObj)
    Scope (_SB.PCI0.RP07)
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
    }

    External (_SB.PCI0.RP08, DeviceObj)
    Scope (_SB.PCI0.RP08)
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
    }
    //RP09 -> SSDT-NVME.dsl ignore

    External (_SB.PCI0.RP10, DeviceObj)
    Scope (_SB.PCI0.RP10)
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
    }

    External (_SB.PCI0.RP11, DeviceObj)
    Scope (_SB.PCI0.RP11)
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
    }

    External (_SB.PCI0.RP12, DeviceObj)
    Scope (_SB.PCI0.RP12)
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
    }
    

    External (_SB.PCI0.RP13, DeviceObj)
    Scope (_SB.PCI0.RP13)
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
    }

    External (_SB.PCI0.RP14, DeviceObj)
    Scope (_SB.PCI0.RP14)
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
    }

    External (_SB.PCI0.RP15, DeviceObj)
    Scope (_SB.PCI0.RP15)
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
    }

    External (_SB.PCI0.RP16, DeviceObj)
    Scope (_SB.PCI0.RP16)
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
    }

    External (_SB.PCI0.RP17, DeviceObj)
    Scope (_SB.PCI0.RP17)
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
    }

    External (_SB.PCI0.RP18, DeviceObj)
    Scope (_SB.PCI0.RP18)
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
    }

    External (_SB.PCI0.RP19, DeviceObj)
    Scope (_SB.PCI0.RP19)
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
    }

    External (_SB.PCI0.RP20, DeviceObj)
    Scope (_SB.PCI0.RP20)
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
    }
}

