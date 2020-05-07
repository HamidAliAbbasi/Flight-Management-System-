<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" import="java.sql.*"
	import="java.text.SimpleDateFormat" import="java.text.DateFormat"
	import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Registration Confirmed for Flight ${param.flight}</title>
</head>
<body>
<form action = "user.jsp">
	<input type="submit" value="Back to Search" />
</form>
<br />
	<div>Flight Number: ${param.flight}</div>
	<div></div>

	<%
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		Connection con = DriverManager.getConnection(
				"jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336", "admin", "password123");
		Statement st = con.createStatement();
		String flightNum = request.getParameter("flight");

		ResultSet flightCapacity = st.executeQuery(
				"SELECT a.Capacity FROM Aircraft a, Operates o WHERE o.ACID = a.ACID AND o.FlightNumber = "
						+ request.getParameter("flight"));
		int capacity = 0;
		while (flightCapacity.next()) {
			capacity = flightCapacity.getInt("a.Capacity");
		}

		ResultSet currentCapcity = st.executeQuery(
				"SELECT COUNT(*) FROM AssociatedWith aw WHERE aw.FlightNumber = " + request.getParameter("flight"));
		int currNum = 0;
		while (currentCapcity.next()) {
			currNum = currentCapcity.getInt("COUNT(*)");
		}
		out.print("Capacity: " + capacity);
		out.print("\n");
		out.print("Current Num of Passengers: " + currNum);
		out.print("\n");

		if (currNum < capacity) {

			ResultSet maxTicketNumber = st.executeQuery("SELECT TicketNumber FROM Ticket a");
			int max = 0;
			while (maxTicketNumber.next()) {
				if (maxTicketNumber.getInt("a.TicketNumber") > max) {
					max = maxTicketNumber.getInt("a.TicketNumber");
				}

			}
			String maxString = Integer.toString(max + 1);
			Date date = Calendar.getInstance().getTime();
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			String strDate = dateFormat.format(date);


			String registerTicketString = String.format(
					"Insert INTO Ticket(TicketNumber, Fare, BookingFee, Class, PurchaseDate) VALUES(%s, %s, %s, '%s', '%s')",
					maxString, 50, 100, request.getParameter("class"), strDate);
			st.executeUpdate(registerTicketString);

			String registerAssociatedString = String.format("Insert INTO AssociatedWith VALUES(%s, %s)", flightNum,
					maxString);
			st.executeUpdate(registerAssociatedString);

			String registerUserString = String.format("Insert INTO Books VALUES(%s, '%s')", maxString,
					session.getAttribute("email").toString());
			st.executeUpdate(registerUserString);
			out.print("<br />");
			out.print("Registration Confirmed!"); 
		} else {
			String addWaitListString = String.format("Insert INTO Waitlist VALUES('%s', %s)", session.getAttribute("email").toString(), flightNum);
			st.executeUpdate(addWaitListString);
			out.print("<br />");
			out.print("Added to WaitList"); 

		}
	%>
</body>
<a href="logout.jsp">Logout</a>
</html>