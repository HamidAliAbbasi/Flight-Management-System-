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
String month= request.getParameter("Month");

Class.forName("com.mysql.jdbc.Driver").newInstance();
Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
//Statement st = con.createStatement();
String select = "select * from Ticket where  MONTH(PurchaseDate) = (?)";

PreparedStatement ps=con.prepareStatement(select);
ps.setString(1,month);
float booking_fee=0,fare=0;
ResultSet rs=ps.executeQuery();
out.print("<table>");

//make a row
out.print("<tr>");
//make a column
out.print("<td>");
//print out column header
out.print("TicketNumber");
out.print("</td>");
//make a column
out.print("<td>");
out.print("Fare");
out.print("</td>");
//make a column
out.print("<td>");
out.print("BookingFee");
out.print("</td>");
out.print("<td>");
out.print("Class");
out.print("</td>");
out.print("<td>");
out.print("PurchaseDate");
out.print("</td>");
out.print("</tr>");
while (rs.next()) {
	//make a row
	out.print("<tr>");
	//make a column
	out.print("<td>");
	//Print out current bar name:
	out.print(rs.getString("TicketNumber"));
	out.print("</td>");
	out.print("<td>");
	//Print out current beer name:
	out.print(rs.getString("Fare"));
	fare+=Float.valueOf(rs.getString("Fare"));
	out.print("</td>");
	out.print("<td>");
	//Print out current price
	out.print(rs.getString("BookingFee"));
	booking_fee+=Float.valueOf(rs.getString("BookingFee"));
	out.print("</td>");
	out.print("<td>");
	//Print out current price
	out.print(rs.getString("Class"));
	out.print("</td>");
	out.print("<td>");
	//Print out current price
	out.print(rs.getString("PurchaseDate"));
	out.print("</td>");
	out.print("</tr>");

}
out.print("</table>");

out.println("Total Booking Fee for this month is: $"+ booking_fee+"\n");
out.println("Total Fare for this month is: $"+ fare);


%>
<a href="logout.jsp">Logout</a>
</body>
</html>