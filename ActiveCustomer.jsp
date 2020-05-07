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
String query = "select  account.fname,account.lname, SUM(if (Customer.customer_email = account.email and b.Email = Customer.customer_email AND b.TicketNumber = Ticket.TicketNumber AND AssociatedWith.TicketNumber = Ticket.TicketNumber, Ticket.Fare+ Ticket.BookingFee, 0)) as total_GRevenue"
			   +" FROM  Books b , account, Customer, Ticket, AssociatedWith"
			   +" group by account.fname,account.lname"
			   +" order by total_GRevenue DESC";


rs = st.executeQuery(query);

out.print("<table>");

//make a row
out.print("<tr>");
//make a column
out.print("<td>");
//print out column header
out.print("FName");
out.print("</td>");
//make a column
out.print("<td>");
out.print("LName");
out.print("</td>");
out.print("<td>");
out.print("Total GRevenue($)");
out.print("</td>");
while(rs.next()){
out.print("<tr>");
	//make a column
	out.print("<td>");
	//Print out current bar name:
	out.print(rs.getString("fname"));
	out.print("</td>");
	out.print("<td>");
	//Print out current beer name:
	out.print(rs.getString("lname"));
	out.print("</td>");
	out.print("<td>");
	//Print out current beer name:
	out.print(rs.getString("total_GRevenue"));
	out.print("</td>");
	out.print("</tr>");

}
out.print("</table>");
%>



</body>
<a href="logout.jsp">Logout</a>
</html>