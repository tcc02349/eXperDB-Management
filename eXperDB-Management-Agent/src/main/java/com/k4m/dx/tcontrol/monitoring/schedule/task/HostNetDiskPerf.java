package com.k4m.dx.tcontrol.monitoring.schedule.task;


import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.hyperic.sigar.FileSystem;
import org.hyperic.sigar.FileSystemUsage;
import org.hyperic.sigar.NetInterfaceStat;
import org.hyperic.sigar.Sigar;
import org.hyperic.sigar.SigarException;
import org.hyperic.sigar.SigarProxy;
import org.hyperic.sigar.SigarProxyCache;
import org.slf4j.Logger;

import com.k4m.dx.tcontrol.monitoring.schedule.runner.CounterBasket;
import com.k4m.dx.tcontrol.monitoring.schedule.util.anotation.ExperDB;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.counters.CounterConstants;

public class HostNetDiskPerf {
	static char ch_l = 'l';
	static char ch_o = 'o';
	static int SLEEP_TIME = 2000;
	static Sigar sigarImpl = new Sigar();
	static SigarProxy sigar = SigarProxyCache.newInstance(sigarImpl, SLEEP_TIME);
	private Set<String> fsExceptionOccured = new HashSet<String>();
	
	private static String[] netIf = null;
	private static FileSystem[] fs = null;

	private static HashMap<String, Map<String, Long>> previousNetworkStats = new HashMap<String, Map<String, Long>>();
	private static HashMap<String, Map<String, Long>> previousDiskStats = new HashMap<String, Map<String, Long>>();
	private static final String RX_DELTA = "rxD";
	private static final String TX_DELTA = "txD";
	private static final String READ_DELTA = "rdD";
	private static final String WRITE_DELTA = "wrD";
	private static volatile long rxTotalBytesPerSec = 0L;
	private static volatile long txTotalBytesPerSec = 0L;
	private static volatile long readTotalBytesPerSec = 0L;
	private static volatile long writeTotalBytesPerSec = 0L;

	public static long getRxTotalBytesPerSec() {
		return HostNetDiskPerf.rxTotalBytesPerSec;
	}

	public static long getTxTotalBytesPerSec() {
		return HostNetDiskPerf.txTotalBytesPerSec;
	}

	public static long getReadTotalBytesPerSec() {
		return HostNetDiskPerf.readTotalBytesPerSec;
	}

	public static long getWriteTotalBytesPerSec() {
		return HostNetDiskPerf.writeTotalBytesPerSec;
	}

	@ExperDB(interval = 10000)
	public void process(CounterBasket pw) {
		try {
			netUsage(10);
			diskIO(10);
			SigarProxyCache.clear(sigar);
		} catch (Exception e) {
			//Logger.println("A141", 10, "HostPerfProcess10s", e);
		}
	}

	private void netUsage(int checkIntervalSec) {
		try {
			if (netIf == null) {
				netIf = sigar.getNetInterfaceList();
			}
			long tmpRxTotal = 0L;
			long tmpTxTotal = 0L;

			for (int i = 0; i < netIf.length; i++) {
				String netIfName = netIf[i];
				
				System.out.println("netIfName: " + netIfName);
				
				if(netIfName.length() >= 2) {
					if(netIfName.charAt(0) == ch_l && netIfName.charAt(1) == ch_o) {
						continue;
					}
				}
				NetInterfaceStat net = null;
				try {
					net = sigar.getNetInterfaceStat(netIfName);
				} catch (SigarException e) {
					// Ignore the exception when trying to stat network interface
					//Logger.println("A143", 300, "SigarException trying to stat network device " + netIfName, e);
					continue;
				}
				Map<String, Long> netMap = new HashMap<String, Long>();
				long rxBytes = net.getRxBytes();
				long txBytes = net.getTxBytes();

				netMap.put(CounterConstants.HOST_NET_RX_BYTES, rxBytes);
				netMap.put(CounterConstants.HOST_NET_TX_BYTES, txBytes);

				Map<String, Long> preMap = previousNetworkStats.get(netIfName);

				if (preMap != null) {
					long rxDelta = (rxBytes - preMap.get(CounterConstants.HOST_NET_RX_BYTES)) / checkIntervalSec; // per sec delta
					long txDelta = (txBytes - preMap.get(CounterConstants.HOST_NET_TX_BYTES)) / checkIntervalSec; // per sec delta

					netMap.put(this.RX_DELTA, rxDelta);
					netMap.put(this.TX_DELTA, txDelta);

					tmpRxTotal += rxDelta;
					tmpTxTotal += txDelta;
					
					System.out.println("rxDelta: " + rxDelta + " txDelta : " + txDelta);
				}
				previousNetworkStats.put(netIfName, netMap);
				System.out.println("tmpRxTotal: " + tmpRxTotal + " tmpTxTotal : " + tmpTxTotal);
			}

			HostNetDiskPerf.rxTotalBytesPerSec = tmpRxTotal;
			HostNetDiskPerf.txTotalBytesPerSec = tmpTxTotal;

		} catch (SigarException se) {
			//Logger.println("A144", 60, "SigarException on net usage", se);
			HostNetDiskPerf.rxTotalBytesPerSec = 0;
			HostNetDiskPerf.txTotalBytesPerSec = 0;
		}
	}

	private void diskIO(int checkIntervalSec) {
		try {
			if (fs == null) {
				fs = sigar.getFileSystemList();
			}
			long tmpReadTotal = 0L;
			long tmpWriteTotal = 0L;

			for (int i = 0; i < fs.length; i++) {
				FileSystemUsage usage = null;
				try {
					usage = sigar.getFileSystemUsage(fs[i].getDirName());
				} catch (SigarException e) {
					if(!fsExceptionOccured.contains(fs[i].getDirName())) {
						// Ignore the exception when trying to stat file interface
						//Logger.println("A145", 300, "SigarException trying to stat file system device " + fs[i], e);
						fsExceptionOccured.add(fs[i].getDirName());
					}
					continue;
				}
				fsExceptionOccured.remove(fs[i].getDirName());
				Map<String, Long> fsMap = new HashMap<String, Long>();
				long readBytes = usage.getDiskReadBytes();
				long writeBytes = usage.getDiskWriteBytes();

				fsMap.put(CounterConstants.HOST_DISK_READ_BYTES, readBytes);
				fsMap.put(CounterConstants.HOST_DISK_WRITE_BYTES, writeBytes);

				Map<String, Long> preMap = previousDiskStats.get(fs[i].getDevName());

				if (preMap != null) {
					long readDelta = (readBytes - preMap.get(CounterConstants.HOST_DISK_READ_BYTES)) / checkIntervalSec; // per sec delta
					long writeDelta = (writeBytes - preMap.get(CounterConstants.HOST_DISK_WRITE_BYTES)) / checkIntervalSec; // per sec delta

					fsMap.put(this.READ_DELTA, readDelta);
					fsMap.put(this.WRITE_DELTA, writeDelta);

					tmpReadTotal += readDelta;
					tmpWriteTotal += writeDelta;
				}
					System.out.println(fs[i].getDevName() + " tmpReadTotal : " + tmpReadTotal + " tmpWriteTotal : " + tmpWriteTotal);
				previousDiskStats.put(fs[i].getDevName(), fsMap);
			}

			HostNetDiskPerf.readTotalBytesPerSec = tmpReadTotal;
			HostNetDiskPerf.writeTotalBytesPerSec = tmpWriteTotal;

		} catch (SigarException se) {
			//Logger.println("A144", 60, "SigarException on net usage", se);
			HostNetDiskPerf.rxTotalBytesPerSec = 0;
			HostNetDiskPerf.txTotalBytesPerSec = 0;
		}
	}
	
	public void test() throws Exception {
		this.netUsage(10);
		this.diskIO(10);
	}
	
	public static void main(String[] args) throws Exception {
		HostNetDiskPerf test = new HostNetDiskPerf();
		test.test();
		
	}

}
