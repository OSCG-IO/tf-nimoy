import java.io.*;

class jNext
{ 
    public static void main(String args[]) 
    { 
	if (args.length != 2) {
          System.err.println("Two argements (whse, dist) required");
	  System.exit(1);
	}
	int whse=0;
	int dist=0;
	try {
          whse = Integer.parseInt(args[0]);
          dist = Integer.parseInt(args[1]);
	} catch (NumberFormatException e) {
        	System.err.println("Both arguments must be an integer.");
        	System.exit(1);
        }
        int nextOID = getNextOid(whse, dist);
        System.out.println("nextOID = " + nextOID);
        System.exit(0);
    } 

    public static Integer getNextOid(int p_whse, int p_dist) {
      //String next_oid  = System.getenv("next_oid");
      String s_whse = Integer.toString(p_whse);
      String s_dist = Integer.toString(p_dist);
      Integer rc = 2999; 

      try {
          String[] cmd = { "/home/ec2-user/test/bigsql/lmm/remote/etcd/get-next-oid.sh", s_whse, s_dist };
          Process p = Runtime.getRuntime().exec(cmd);
          BufferedReader reader = new BufferedReader(new InputStreamReader(
          p.getInputStream()));
          String s;
          while ((s = reader.readLine()) != null) {
            rc = Integer.valueOf(s);
          }
       } catch (Exception e) {
          e.printStackTrace();
       }

        //System.out.println("whse=" + s_whse + ", dist=" + s_dist + ", next_oid=" + rc);

       return(rc);
    }
} 
