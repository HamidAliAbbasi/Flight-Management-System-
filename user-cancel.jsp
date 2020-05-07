<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" import="java.text.SimpleDateFormat"
	import="java.util.Date"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Booking Removed!</title>
</head>
<body>

<form action = "user.jsp">
	<input type="submit" value="Back to Search" />
</form>
<br />

	<div>Your Ticket ${param.ticket} has been Deleted!</div>

		<%
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336", "admin", "password123");
			Statement st = con.createStatement();
			String ticketNum = request.getParameter("ticket");

			String query = String.format("DELETE from Ticket WHERE TicketNumber = %s", ticketNum); 
			st.executeUpdate(query);
			
			query = String.format("DELETE from AssociatedWith WHERE TicketNumber = %s", ticketNum); 
			st.executeUpdate(query);
			
			query = String.format("DELETE from Books WHERE TicketNumber = %s", ticketNum); 
			st.executeUpdate(query);
			
		%>

</body>
<a href="logout.jsp">Logout</a>
</html>