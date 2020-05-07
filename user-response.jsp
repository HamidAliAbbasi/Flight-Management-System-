<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" import="java.text.SimpleDateFormat"
	import="java.util.Date"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form action = "user.jsp">
	<input type="submit" value="Back to Search" />
</form>
<br />
	${param.airportDepart} to ${param.airportArrive}
	<br />
	<br /> Flight Type: ${param.tripType}

	<br />
	<br />
	<br />

	<b>Departure Flights:</b>
	<form action="user-register.jsp">
	<table>
		<tr>
			<td>Flight Number</td>
			<td>Departure Location</td>
			<td>Arrival Location</td>
			<td>Arrival Time</td>
			<td>Departure Time</td>
			<td>Register</td>
			
		</tr>

		<%
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336", "admin", "password123");
			Statement st = con.createStatement();
			String airportDepart = request.getParameter("airportDepart");
			String airportArrive = request.getParameter("airportArrive");

			String departureDateString = request.getParameter("departureDate");

			// String query = "SELECT a.FlightNumber, a.APID, d.APID FROM Arrives_At a, Departs d WHERE a.FlightNumber = d.FlightNumber AND d.APID = '" + airportDepart + "' AND a.APID = '" + airportArrive + "'";
			String selectDept = "SELECT a.FlightNumber, a.APID, d.APID, f.ArrivalTime, f.DepartureTime ";
			String fromDept = "FROM Arrives_At a, Departs d, Flight f ";
			String whereDept = "WHERE a.FlightNumber = d.FlightNumber AND a.FlightNumber = f.FlightNumber AND d.APID = '"
					+ airportDepart + "' AND a.APID = '" + airportArrive + "' AND DATE(f.DepartureTime) = '"
					+ departureDateString + "' AND a.FlightNumber NOT IN ";
			
			String select = String.format("(SELECT a.FlightNumber "); 
			String from = String.format("FROM Books b, AssociatedWith a, Flight f, Arrives_At ar, Departs d, Ticket t "); 
			String where = String.format("WHERE b.Email = '%s' AND t.TicketNumber = b.TicketNumber AND a.TicketNumber = b.TicketNumber AND f.FlightNumber = a.FlightNumber AND ar.FlightNumber = a.FlightNumber AND d.FlightNumber = a.FlightNumber ", session.getAttribute("email").toString()); 
			
			String notInWaitList = String.format(" UNION SELECT w.FlightNumber FROM Waitlist w WHERE w.email = '%s' )", session.getAttribute("email").toString()); 
			ResultSet rs = st.executeQuery(selectDept + fromDept + whereDept + select + from + where + notInWaitList);
			
			while (rs.next()) {
				//make a row
				out.print("<tr>");
				//make a column

				out.print("<td>");
				out.print(rs.getString("a.FlightNumber"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs.getString("d.APID"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs.getString("a.APID"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs.getString("f.DepartureTime"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs.getString("f.ArrivalTime"));
				out.print("</td>");
				
				out.print("<td>");
				out.print("<select name='class'>");
				out.print("<option>Economy</option>");
				out.print("<option>FirstClass</option>");
				out.print("<option>Business</option>");
				out.print("</select>");
				out.print("</td>"); 
				
				out.print("<td>");
				String button = String.format("<button id='%s' onclick='javascript:MyFunction(%s)'>Register</button>", rs.getString("a.FlightNumber"), rs.getString("a.FlightNumber"));
				out.print(button);
				String input = String.format("<input type='hidden' name='flight' value='%s'", rs.getString("a.FlightNumber")); 
				out.print(input); 
				out.print("</td>");


				out.print("</tr>");
			}
		%>
	</table>
	</form>
	<br />
	<br />
	<div></div>

	<%
		if (request.getParameter("tripType").equals("Round Trip")) {
			out.print("<b>Return Flights:</b>"); 
			out.print("<form action=\"user-register.jsp\">"); 
			out.print("<table>"); 
			out.print("<tr>");
			out.print("<td>Flight Number</td>");
			out.print("<td>Departure Location</td>");
			out.print("<td>Arrival Location</td>");
			out.print("<td>Arrival Time</td>");
			out.print("<td>Departure Time</td>"); 
			out.print("<td>Register</td>"); 

			out.print("</tr>");
			String returnDateString = request.getParameter("returnDate");

			String selectReturn = "SELECT a.FlightNumber, a.APID, d.APID, f.ArrivalTime, f.DepartureTime ";
			String fromReturn = "FROM Arrives_At a, Departs d, Flight f ";
			String whereReturn = "WHERE a.FlightNumber = d.FlightNumber AND a.FlightNumber = f.FlightNumber AND d.APID = '"
					+ airportArrive + "' AND a.APID = '" + airportDepart + "' AND DATE(f.DepartureTime) = '"
					+ returnDateString + "'";
			ResultSet rs1 = st.executeQuery(selectReturn + fromReturn + whereReturn);
			
			while (rs1.next()) {
				//make a row
				out.print("<tr>");
				//make a column

				out.print("<td>");
				out.print(rs1.getString("a.FlightNumber"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs1.getString("d.APID"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs1.getString("a.APID"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs1.getString("f.DepartureTime"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs1.getString("f.ArrivalTime"));
				out.print("</td>");
				
				out.print("<td>");
				out.print("<select name='class'>");
				out.print("<option>Economy</option>");
				out.print("<option>FirstClass</option>");
				out.print("</select>");
				out.print("</td>"); 
				
				out.print("<td>");
				String button = String.format("<button id='%s' onclick='javascript:MyFunction(%s)'>Register</button>", rs1.getString("a.FlightNumber"), rs1.getString("a.FlightNumber"));
				out.print(button);
				String input = String.format("<input type='hidden' name='flight' value='%s'", rs1.getString("a.FlightNumber")); 
				out.print(input); 
				out.print("</td>");

				out.print("</tr>");
			}
			out.print("</table>"); 
			out.print("</form>"); 

			
			

		}
	%>
	
	<script type="text/javascript">
        MyFunction = function(flight){
            console.log(flight);
            console.log(document.getElementById(flight).value);
        }
    </script>


</body>
<a href="logout.jsp">Logout</a>
</html>