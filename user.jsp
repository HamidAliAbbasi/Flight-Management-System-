<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Travel Agency Portal</title>
</head>
<body>
	<form action="user-response.jsp">
		<div>Airport From:</div>
		<select name="airportDepart">
			<option>EWR</option>
			<option>IIL</option>
			<option>JFK</option>
		</select> <br />
		<br />

		<div>Airport To:</div>
		<select name="airportArrive">
			<option>EWR</option>
			<option>IIL</option>
			<option>JFK</option>
		</select> <br />
		<br />

		<div>Trip Type:</div>
		<select name="tripType">
			<option>One-Way</option>
			<option>Round Trip</option>
		</select> <br />
		<br />

		<div>Departure Date:</div>
		<input type="date" name="departureDate"> <br />
		<br />

		<div>Return Date:</div>
		<input type="date" name="returnDate"> <br />
		<br /> <input type="submit" value="Search" />
	</form>
	
	<form action="user-bookings.jsp">
	<input type="submit" value="View My Bookings" />
	</form>

</body>
<a href="logout.jsp">Logout</a>
</html>