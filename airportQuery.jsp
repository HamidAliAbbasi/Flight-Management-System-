<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import ="java.sql.*" %>
<!DOCTYPE html>
<html lang="en-US">
<head>
    
    <meta charset="UTF-8">
    <title>Travel Agency User Portal</title>
   <link rel="stylesheet" type="text/css" href="style/index.css" />
</head>
<body>

<% 
String APID= request.getParameter("APID");
out.println(APID);

Class.forName("com.mysql.jdbc.Driver").newInstance();
Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
//Statement st = con.createStatement();
String select = "select  Arrives_At.FlightNumber, Arrives_At.APID Arrival, Departs.APID Departure from Arrives_At inner join Departs on Arrives_At.FlightNumber=Departs.FlightNumber where Arrives_At.APID=(?) OR Departs.APID=(?)";

PreparedStatement ps=con.prepareStatement(select);
ps.setString(1,APID);
ps.setString(2,APID);
ResultSet rs=ps.executeQuery();
out.print("<table>");

//make a row
out.print("<tr>");
//make a column
out.print("<td>");
//print out column header
out.print("FlightNumber");
out.print("</td>");
//make a column
out.print("<td>");
out.print("Arrival");
out.print("</td>");
//make a column
out.print("<td>");
out.print("Departure");
out.print("</td>");

out.print("</tr>");
while (rs.next()) {
	//make a row
	out.print("<tr>");
	//make a column
	out.print("<td>");
	//Print out current bar name:
	out.print(rs.getString("FlightNumber"));
	out.print("</td>");
	out.print("<td>");
	//Print out current beer name:
	out.print(rs.getString("Arrival"));
	out.print("</td>");
	out.print("<td>");
	//Print out current price
	out.print(rs.getString("Departure"));
	out.print("</td>");
	
	out.print("</tr>");

}
out.print("</table>");
%>



</body>
<a href="logout.jsp">Logout</a>
</html>