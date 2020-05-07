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
<% Class.forName("com.mysql.jdbc.Driver").newInstance();
Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
String entity = request.getParameter("command");
String name =request.getParameter("Name");
if(name=="")
	out.println("Please enter a particular Flight/Airline/Customer");
else if(entity.equals("1") && name!=""){
	String select = "select  distinct F.FlightNumber, SUM(if (AssociatedWith.TicketNumber = Ticket.TicketNumber AND F.FlightNumber = AssociatedWith.FlightNumber , Ticket.Fare+ Ticket.BookingFee, 0)) as total_Revenue"
			+" FROM Flight F, Ticket , AssociatedWith"
			+" where F.FlightNumber= (?)";

	PreparedStatement ps=con.prepareStatement(select);
	ps.setString(1,name);
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
	out.print("Total Revenue($)");
	out.print("</td>");
	//make a column
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
	out.print(rs.getString("total_Revenue"));
	out.print("</td>");
	out.print("</tr>");

	}
	out.print("</table>");}


else if (entity.equals("2") && name!=""){
	String select = "select a.ALID, SUM(if(o.ALID = a.ALID AND F.FlightNumber = o.FlightNumber AND AssociatedWith.TicketNumber = Ticket.TicketNumber AND F.FlightNumber = AssociatedWith.FlightNumber, Ticket.Fare+ Ticket.BookingFee, 0)) as total_Revenue"
			+" FROM Flight F, Airline a , Operates o, Ticket, AssociatedWith"
			+" where a.ALID=(?)";

	PreparedStatement ps=con.prepareStatement(select);
	ps.setString(1,name);
	ResultSet rs=ps.executeQuery();
	out.print("<table>");

	//make a row
	out.print("<tr>");
	//make a column
	out.print("<td>");
	//print out column header
	out.print("ALID");
	out.print("</td>");
	//make a column
	out.print("<td>");
	out.print("Total Revenue($)");
	out.print("</td>");
	//make a column
	while (rs.next()) {
	//make a row
	out.print("<tr>");
	//make a column
	out.print("<td>");
	//Print out current bar name:
	out.print(rs.getString("ALID"));
	out.print("</td>");
	out.print("<td>");
	//Print out current beer name:
	out.print(rs.getString("total_Revenue"));
	out.print("</td>");
	out.print("</tr>");

	}
	out.print("</table>");}

else if (entity.equals("3")&&name!=""){

String select = "select  account.fname,account.lname, SUM(if (Customer.customer_email = account.email and b.Email = Customer.customer_email AND b.TicketNumber = Ticket.TicketNumber AND AssociatedWith.TicketNumber = Ticket.TicketNumber, Ticket.Fare+ Ticket.BookingFee, 0)) as total_Revenue"
    			+" FROM  Books b , account, Customer, Ticket, AssociatedWith"
				+" where account.fname=(?)";
	PreparedStatement ps=con.prepareStatement(select);
	ps.setString(1,name);
	ResultSet rs=ps.executeQuery();
	out.print("<table>");

	//make a row
	out.print("<tr>");
	//make a column
	out.print("<td>");
	//print out column header
	out.print("fname");
	out.print("</td>");
	out.print("<td>");
	//print out column header
	out.print("lname");
	out.print("</td>");
	//make a column
	out.print("<td>");
	out.print("Total Revenue($)");
	out.print("</td>");
	//make a column
	while (rs.next()) {
	//make a row
	out.print("<tr>");
	//make a column
	out.print("<td>");
	//Print out current bar name:
	out.print(rs.getString("fname"));
	out.print("</td>");
	out.print("<td>");
	//Print out current bar name:
	out.print(rs.getString("lname"));
	out.print("</td>");
	out.print("<td>");
	//Print out current beer name:
	out.print(rs.getString("total_Revenue"));
	out.print("</td>");
	out.print("</tr>");

	}
	out.print("</table>");}
	
	
	
%>
	</body>
	<a href="logout.jsp">Logout</a>
	</html>