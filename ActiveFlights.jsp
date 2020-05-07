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
Class.forName("com.mysql.jdbc.Driver").newInstance();
Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
Statement st = con.createStatement();
ResultSet rs;
String query = "select  distinct F.FlightNumber, count(Ticket.TicketNumber) flights_sold "+
"FROM Flight F, Ticket , AssociatedWith"+
" where F.FlightNumber = AssociatedWith.FlightNumber"+
" And AssociatedWith.TicketNumber = Ticket.TicketNumber"+ 
" group by F.FlightNumber"+
" order by flights_sold DESC";

rs = st.executeQuery(query);

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
out.print("Flights_sold");
out.print("</td>");
while(rs.next()){
out.print("<tr>");
	//make a column
	out.print("<td>");
	//Print out current bar name:
	out.print(rs.getString("FlightNumber"));
	out.print("</td>");
	out.print("<td>");
	//Print out current beer name:
	out.print(rs.getString("flights_sold"));
	out.print("</td>");
	out.print("</tr>");

}
out.print("</table>");
%>



</body>
<a href="logout.jsp">Logout</a>
</html>