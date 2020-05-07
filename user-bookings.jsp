<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" import="java.sql.*" import="java.text.SimpleDateFormat" import="java.text.DateFormat"
	import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>My bookings</title>
</head>
<body>
<form action = "user.jsp">
	<input type="submit" value="Back to Search" />
</form>
<br />

<h1>My Flights: </h1>

<form action="user-cancel.jsp">
	<table>
		<tr>
			<td>Ticket Number</td>
			<td>Flight Number</td>
			<td>Departure Time</td>
			<td>Arrival Time</td>
			<td>Type</td>
			<td>Departure Location</td>
			<td>Arrival Location</td>
			<td>Fare</td>
			<td>Booking Fee</td>
			<td>Class</td>
			<td>Purchase Date</td>
			
			<td>Cancel (Not Available for Economy Class)</td>
			
		</tr>

		<%
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336", "admin", "password123");
			Statement st = con.createStatement();
			String select = String.format("SELECT b.TicketNumber, a.FlightNumber, f.DepartureTime, f.ArrivalTime, f.Type, d.APID, ar.APID,  t.Fare, t.BookingFee, t.Class, t.PurchaseDate "); 
			String from = String.format("FROM Books b, AssociatedWith a, Flight f, Arrives_At ar, Departs d, Ticket t "); 
			String where = String.format("WHERE b.Email = '%s' AND t.TicketNumber = b.TicketNumber AND a.TicketNumber = b.TicketNumber AND f.FlightNumber = a.FlightNumber AND ar.FlightNumber = a.FlightNumber AND d.FlightNumber = a.FlightNumber", session.getAttribute("email").toString()); 

			
			ResultSet rs = st.executeQuery(select + from + where);
			
			while (rs.next()) {
				//make a row
				out.print("<tr>");
				//make a column

				out.print("<td>");
				out.print(rs.getString("b.TicketNumber"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs.getString("a.FlightNumber"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs.getString("f.DepartureTime"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs.getString("f.ArrivalTime"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs.getString("f.Type"));
				out.print("</td>");
				
				out.print("<td>");
				out.print(rs.getString("d.APID"));
				out.print("</td>");
				
				out.print("<td>");
				out.print(rs.getString("ar.APID"));
				out.print("</td>");
				
				out.print("<td>");
				out.print(rs.getString("t.Fare"));
				out.print("</td>");
				
				out.print("<td>");
				out.print(rs.getString("t.BookingFee"));
				out.print("</td>");
				
				out.print("<td>");
				out.print(rs.getString("t.Class"));
				out.print("</td>");
				
				out.print("<td>");
				out.print(rs.getString("t.PurchaseDate"));
				out.print("</td>");
				
				SimpleDateFormat sdfo = new SimpleDateFormat("yyyy-MM-dd"); 
				Date ticketDate = sdfo.parse(rs.getString("f.DepartureTime")); 
				
				Date dateToday = Calendar.getInstance().getTime();  
				String strDate = sdfo.format(dateToday); 
				dateToday = sdfo.parse(strDate); 
				
				if(rs.getString("t.Class").equals("Economy") || dateToday.compareTo(ticketDate) > 0){
					
				} else {
					out.print("<td>");
					out.print("<input type='submit' value='Cancel' />");
					String input = String.format("<input type='hidden' name='ticket' value='%s'", rs.getString("b.TicketNumber")); 
					out.print(input); 

					out.print("</td>");
				}
				


				out.print("</tr>");
			}
		%>
	</table>
	</form>
	<h1>On WaitList: </h1>
	<table>
		<tr>
			<td>Flight Number</td>
			<td>Departure Time</td>
			<td>Arrival Time</td>
			<td>Type</td>
			<td>Departure Location</td>
			<td>Arrival Location</td>
		</tr>
		
		<%
		String selectWait = String.format("SELECT w.FlightNumber,  f.DepartureTime, f.ArrivalTime, f.Type, d.APID, ar.APID "); 
		String fromWait = String.format("FROM Waitlist w, Flight f, Arrives_At ar, Departs d "); 
		String whereWait = String.format("WHERE w.email = '%s' AND f.FlightNumber = w.FlightNumber AND ar.FlightNumber = w.FlightNumber AND d.FlightNumber = w.FlightNumber", session.getAttribute("email").toString()); 
		
		ResultSet rs1 = st.executeQuery(selectWait + fromWait + whereWait);
		
		while (rs1.next()) {
			//make a row
			out.print("<tr>");

			out.print("<td>");
			out.print(rs1.getString("w.FlightNumber"));
			out.print("</td>");

			out.print("<td>");
			out.print(rs1.getString("f.DepartureTime"));
			out.print("</td>");

			out.print("<td>");
			out.print(rs1.getString("f.ArrivalTime"));
			out.print("</td>");

			out.print("<td>");
			out.print(rs1.getString("f.Type"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs1.getString("d.APID"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs1.getString("ar.APID"));
			out.print("</td>");
			
			out.print("</tr>");
		}
		
		%>
		
		
		</table>

</body>
<a href="logout.jsp">Logout</a>
</html>