package com.k4m.dx.tcontrol.util;

import java.net.InetAddress;
import java.net.InterfaceAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

import com.k4m.dx.tcontrol.socket.ProtocolID;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class NetworkUtil {
	
	public static ArrayList<HashMap<String, String>> getNetworkInfo() throws Exception{
		ArrayList<HashMap<String, String>> listNetwork = new ArrayList<HashMap<String, String>>();
		try
		{
			Enumeration<NetworkInterface> networkInterfaces = NetworkInterface.getNetworkInterfaces();
			while(networkInterfaces.hasMoreElements())
			{
				HashMap<String, String> hp = new HashMap<String, String>();
				
				NetworkInterface networkInterface = networkInterfaces.nextElement();
				List<InterfaceAddress> adds = networkInterface.getInterfaceAddresses();
				if(adds == null)
					continue;
				
				hp.put(ProtocolID.CMD_NETWORK_INTERFACE, networkInterface.getDisplayName().toString());

				String strHostAddress = "";
				String CMD_MACADDRESS = "";
				
				for(InterfaceAddress add : adds)
				{
					if (add == null)
					{
						System.out.println("InterfaceAddress is null");
						continue;
					}
					//System.out.println("InterfaceAddres:"+add.getAddress());
					//System.out.println("Prefixlaenge: "+add.getNetworkPrefixLength());
					//System.out.println("InterfaceBrodacast:"+add.getBroadcast()+"\n");
					
					//listIP.add(add.getAddress());
					strHostAddress = add.getAddress().getHostAddress();
					
					CMD_MACADDRESS = getMacAddress(add.getAddress());
					
				}
				hp.put(ProtocolID.CMD_NETWORK_IP, strHostAddress);
				hp.put(ProtocolID.CMD_MACADDRESS, CMD_MACADDRESS);
				
				listNetwork.add(hp);
				
			}
			
		} catch (SocketException e)
		{
			e.printStackTrace();
		}
		
		return listNetwork;
	}
	
	public static String getMacAddress(InetAddress ip)  throws Exception{
		String strMacAddress = "";
		//InetAddress ip;
		try {

			ip = InetAddress.getLocalHost();
			//System.out.println("Current IP address : " + ip.getHostAddress());
			NetworkInterface.getNetworkInterfaces();
			NetworkInterface network = NetworkInterface.getByInetAddress(ip);

			byte[] mac = network.getHardwareAddress();

			//System.out.print("Current MAC address : ");

			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < mac.length; i++) {
				sb.append(String.format("%02X%s", mac[i], (i < mac.length - 1) ? "-" : ""));
			}
			//System.out.println(sb.toString());
			strMacAddress = sb.toString();

		} catch (UnknownHostException e) {

		} catch (SocketException e){

		}
		
		return strMacAddress;
	}
	
	public static String getLocalServerIp()  throws Exception {

		String ip =	"";

		try{

			Enumeration en	=		NetworkInterface.getNetworkInterfaces();

			while(en.hasMoreElements()){

				NetworkInterface ni	=	(NetworkInterface)en.nextElement();

				Enumeration inetAddresses	=	ni.getInetAddresses();

					while(inetAddresses.hasMoreElements()){

						InetAddress ia	=	(InetAddress)inetAddresses.nextElement();

						if(ia.getHostAddress() != null && ia.getHostAddress().indexOf(".") != -1){

							byte[] address	=	ia.getAddress();
							if(address[0] == 127) continue;
							ip	=	ia.getHostAddress();
							break;				

						}

					}

					if(ip.length()>0){
						break;
					}
			}

		}catch(Exception e){
			e.printStackTrace();
		}

		return ip;
	}


}
