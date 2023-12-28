import struct
import numpy as np
from matplotlib import pyplot as plt # for demo only: remove otherwise

def read_qsd(filename):
    with open(filename, 'rb') as f:
        d = f.read()

    reslen=[]
    nmodes = d.rindex(bytes("XtalDriveTimeFloat".encode('ascii'))) # r = start from end

    pointer = nmodes + 30
    nsensors = d[pointer]
    ns = nsensors
    
    if nsensors != 1 and nsensors != 4:
        raise Exception("Invalid number of sensors, aborting")
    
    pointer += 4
    n = struct.unpack('<I', d[pointer:pointer+4])[0]
    pointer += 1 + (4 * nsensors) + 3
    if d[pointer] != 0xee:
        raise Exception("Invalid value: != 0xee")
    
    pointer += 40
    if d[pointer] != 0x0b:
        raise Exception("Invalid value: != 0x0b")
    
    pointer += 6
    val = struct.unpack('<{}d'.format(n), d[pointer:pointer+n*8])
    val = np.array(val)
    tim = (val - val[0])*86400;
    
    pointer += n*8-1+8*1+3
    n = struct.unpack('<I', d[pointer:pointer+4])[0]
    reslen.append(n)
    pointer += 4
    val = struct.unpack('<{}d'.format(n), d[pointer:pointer+n*8])
    fre = np.array(val)
    
    pointer += n*8-1
    pointer += 7
    val = struct.unpack('<{}d'.format(n), d[pointer:pointer+n*8])
    dis = np.array(val)
    
    pointer += n*8-1
    while True:
        pointer += 9
        n = struct.unpack('<I', d[pointer:pointer+4])[0]
        
        if n == 0:
            nsensors -= 1
            pointer += 40
            n = struct.unpack('<I', d[pointer:pointer+4])[0]
            
            if nsensors == 0:
                break
        
        reslen.append(n)
        pointer -= 2
        pointer += 3*8
        val = np.array(struct.unpack('<{}d'.format(n), d[pointer:pointer+n*8]))
        timtmp = (val - val[0]) * 86400 
        if (len(timtmp)<max(np.shape((tim)))):
            timtmp=np.append(timtmp,0)
        if (len(timtmp)>max(np.shape((tim)))):
            tim=np.append(tim,0)
        tim=np.vstack([tim,timtmp])
        
        pointer += n*8-1
        pointer += 3
        n = struct.unpack('<I', d[pointer:pointer+4])[0]
        
        pointer += 4
        val = struct.unpack('<{}d'.format(n), d[pointer:pointer+n*8])
        val = np.array(val)
        if (len(val)<max(np.shape((fre)))):
            val=np.append(val,0)
        fre=np.vstack([fre,val])        
        
        pointer += n*8-1
        pointer += 7
        val = struct.unpack('<{}d'.format(n), d[pointer:pointer+n*8])
        if (len(val)<max(np.shape((dis)))):
            val=np.append(val,0)
        dis=np.vstack([dis,val])        

        pointer += n*8-1
    return tim, fre, dis, reslen, ns

[tim,fre,dis,reslen,ns]=read_qsd("231118_reOpenQCM1_functionalized_toluene.qsd")

# for demo only: remove for a "useful" application
plt.subplot(211)
for k in range(0,min(np.shape(fre))):
    plt.plot(tim[k,:reslen[k]],fre[k,:reslen[k]]-fre[k][0])
plt.ylabel('freq. variation (Hz)')
plt.subplot(212)
for k in range(0,min(np.shape(dis))):
    plt.plot(tim[k,:reslen[k]],dis[k,:reslen[k]]-dis[k][0])
plt.xlabel('time (s)')
plt.ylabel('dissipation (no unit)')
plt.show()
