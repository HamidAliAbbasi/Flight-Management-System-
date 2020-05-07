<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" import="java.util.Calendar"
	import="java.text.SimpleDateFormat" import="java.text.DateFormat"
	import="java.util.Date"%> 
<!DOCTYPE html>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<title>Travel Agency User Portal</title>
<link rel="stylesheet" type="text/css" href="style/index.css" />
<script src="main.js"></script>
</head>
<body>
	<p id="text"></p>
	<select id="selection" onchange="changeForm()">
		<option value="reservation">Reservations</option>
		<option value="editInformation">Edit Information</option>
		<option value="waitlist">Waitlist</option>
	</select>
	<div id="reservationForm">
		<h1>Reservations</h1>
		<p style="color: red; font-weight: bold;">
			<%
				//  Makes  reservation on behalf of user
    			boolean successfulSearch = true; 
				String email = request.getParameter("email");
				String flightNumber = request.getParameter("flightNumber");
				if (request.getParameter("formType") != null && request.getParameter("formType").equals("reservationForm") && request.getParameter("reservationFormType") != null && request.getParameter("reservationFormType").equals("makeReservationForm")) {
	    			if (email != null && flightNumber != null) {
	                    Class.forName("com.mysql.jdbc.Driver").newInstance();
	                    Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
	                    Statement st = con.createStatement();
	                    String validateUserQuery = String.format("SELECT * FROM account WHERE email = \"%s\"", email);
	                    String validateFlightQuery = String.format("SELECT * FROM Flight WHERE FlightNumber = \"%s\"", flightNumber);
	                    ResultSet rsUser = st.executeQuery(validateUserQuery);
	                    Statement st1 = con.createStatement();
	                    ResultSet rsFlight = st1.executeQuery(validateFlightQuery);
	                    if (!rsUser.next()) {
	                    	out.println("Error: User not found<br>");
	                    	successfulSearch = false;
	                    } 
	                    if (!rsFlight.next()) {
	                    	out.println("Error: Flight not found<br>");
	                    	successfulSearch = false;
	                    }
	                    if (successfulSearch) {
	                		String flightNum = flightNumber;
	
	                		ResultSet flightCapacity = st.executeQuery(
	                				"SELECT a.Capacity FROM Aircraft a, Operates o WHERE o.ACID = a.ACID AND o.FlightNumber = "
	                						+ flightNum);
	                		int capacity = 0;
	                		while (flightCapacity.next()) {
	                			capacity = flightCapacity.getInt("a.Capacity");
	                		}
	
	                		ResultSet currentCapcity = st.executeQuery(
	                				"SELECT COUNT(*) FROM AssociatedWith aw WHERE aw.FlightNumber = " + flightNum);
	                		int currNum = 0;
	                		while (currentCapcity.next()) {
	                			currNum = currentCapcity.getInt("COUNT(*)");
	                		}
	                		out.print("\n");

	                		out.print("Capacity: " + capacity);
	                		out.print("\n");

	                		out.print("current: " + currNum);
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
	                					maxString, 50, 100, request.getParameter("seatType"), strDate);
	                			st.executeUpdate(registerTicketString);
	
	                			String registerAssociatedString = String.format("Insert INTO AssociatedWith VALUES(%s, %s)", flightNum,
	                					maxString);
	                			st.executeUpdate(registerAssociatedString);
	
	                			String registerUserString = String.format("Insert INTO Books VALUES(%s, '%s')", maxString,
	                					email);
	                			st.executeUpdate(registerUserString);
	                			out.print("<br />");
	                			out.print("Registration Confirmed!"); 
	                		} else {
	                			String addWaitListString = String.format("Insert INTO Waitlist VALUES('%s', %s)",email, flightNum);
	                			st.executeUpdate(addWaitListString);
	                			out.print("<br />");
	                			out.print("Added to WaitList"); 
	
	                		}
	                    }
	    			}
				}
    		%>
		</p>
		<form id="makeReservationForm" method="POST">
			<h2>Make Reservation</h2>
			<input type="hidden" name="formType" value="reservationForm" /> 
			<input type="hidden" name="reservationFormType" value="makeReservationForm" /> 
			<input id="email" type="text" placeholder="Customer Email" name="email" required />
			<input id="flightNumber" type="number" placeholder="Flight Number" name="flightNumber" required /><br>
			<p>Seat Type: </p>
			<input type="radio" name="seatType" value="economy" required /> Economy<br>
			<input type="radio" name="seatType" value="business" required /> Business<br>
			<input type="radio" name="seatType" value="first" required /> First<br>
			<button>Make Reservation</button>
		</form>
		<%
	        Connection con1 = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
	        Statement st1;
			if (request.getParameter("formType") != null && request.getParameter("formType").equals("reservationForm") && request.getParameter("reservationFormType") != null && request.getParameter("reservationFormType").equals("editReservationForm")) {
				String query = String.format("UPDATE Ticket SET Class=\"%s\" WHERE TicketNumber=\"%s\";", request.getParameter("seatType"), request.getParameter("ticketNumber"));
	            st1 = con1.createStatement();
	            st1.execute(query);
	            st1.close();

			}
		%>
		<form id="editReservationForm" method="POST">
			<h2>Edit Reservation</h2>
			<input type="hidden" name="formType" value="reservationForm" /> 
			<input type="hidden" name="reservationFormType" value="editReservationForm" />
			<input id="ticketNumber" type="number" placeholder="Ticket Number" name="ticketNumber" required />
			<p>New Flight Type: </p>
			<input type="radio" name="seatType" value="Economy" required /> Economy<br>
			<input type="radio" name="seatType" value="Business" required /> Business<br>
			<input type="radio" name="seatType" value="FirstClass" required /> First Class<br>
			<button>Edit Reservation</button>
		</form>
	</div>




	<div id="editInformationForm">
		<h1>Edit Information</h1>
		<p style="color: red; font-weight: bold; font-size: 15px"></p> 
		<input type="hidden" name="formType" value="editInformationForm" /> 
		<select id="editInformationSelection" onchange="changeEditInformationForm()">
			<option id="addAircraft">Add Aircraft</option>
			<option id="deleteAircraft">Delete Aircraft</option>
			<option id="editAircraft">Edit Aircraft Details</option>
			<option id="addAirport">Add Airport</option>
			<option id="deleteAirport">Delete Airport</option>
			<option id="editAirport">Edit Airport Details</option>
			<option id="addFlight">Add Flight</option>
			<option id="deleteFlight">Delete Flight</option>
			<option id="editFlight">Edit Flight Details</option>
		</select><br>
		<p id="editFormErrorMsg" style="color:red; font-weight:bold; font-size:25px;"></p>
		<p id="editFormSuccessMsg" style="color:green; font-weight:bold; font-size:25px;"></p>

		<%
	            Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
	            Statement st;
	            String[] queries = new String[5];
	            int i = 0;
				String query = "";
				ResultSet rs;
				if (request.getParameter("editInformationForm") != null) {
					if (request.getParameter("editInformationForm").equals("addAircraft")) {
						query = String.format("INSERT INTO Aircraft VALUES (%s, %s, \"%s\", %s)", request.getParameter("acid"), request.getParameter("modelNumber"), request.getParameter("manufacturer"), request.getParameter("capacity"));
						queries[i++] = query;
					} else if (request.getParameter("editInformationForm").equals("deleteAircraft")) {
						query = String.format("DELETE FROM Aircraft WHERE ACID=%s", request.getParameter("acid"));
						queries[i++] = query;
					} else if (request.getParameter("editInformationForm").equals("editAircraft")) {
						if (!request.getParameter("modelNumber").isEmpty()) {
							query = String.format("UPDATE Aircraft SET ModelNumber=\"%s\" WHERE ACID=%s;", request.getParameter("modelNumber"), request.getParameter("acid"));
							queries[i++] = query;
						}
						if (!request.getParameter("manufacturer").isEmpty()) {
							query = String.format("UPDATE Aircraft SET Manufacturer=\"%s\" WHERE ACID=%s;", request.getParameter("manufacturer"), request.getParameter("acid"));
							queries[i++] = query;
						}
						if (!request.getParameter("capacity").isEmpty()) {
							query = String.format("UPDATE Aircraft SET Capacity=%s WHERE ACID=%s;", request.getParameter("capacity"), request.getParameter("acid"));
							queries[i++] = query;
						}					
					} else if (request.getParameter("editInformationForm").equals("addAirport")) {
						query = String.format("INSERT INTO Airport VALUES (\"%s\", \"%s\", \"%s\")", request.getParameter("apid"), request.getParameter("address"), request.getParameter("name"));
						queries[i++] = query;
					} else if (request.getParameter("editInformationForm").equals("deleteAirport")) {
						query = String.format("DELETE FROM Airport WHERE APID=\"%s\"", request.getParameter("apid"));
						queries[i++] = query;
					} else if (request.getParameter("editInformationForm").equals("editAirport")) {
						if (!request.getParameter("address").isEmpty()) {
							query = String.format("UPDATE Airport SET Address=\"%s\" WHERE APID=\"%s\";", request.getParameter("address"), request.getParameter("apid"));
							queries[i++] = query;
						}
						if (!request.getParameter("name").isEmpty()) {
							query = String.format("UPDATE Airport SET Name=\"%s\" WHERE APID=\"%s\";", request.getParameter("name"), request.getParameter("apid"));
							queries[i++] = query;
						}
					} else if (request.getParameter("editInformationForm").equals("addFlight")) {
						query = String.format("INSERT INTO Flight VALUES (%s, \"%s\", \"%s\", \"%s\")", request.getParameter("flightNumber"), request.getParameter("departureTime"), request.getParameter("flightType"), request.getParameter("arrivalTime"));
						queries[i++] = query;
					
					} else if (request.getParameter("editInformationForm").equals("deleteFlight")) {
						query = String.format("DELETE FROM Flight WHERE FlightNumber=%s", request.getParameter("flightNumber"));					
						queries[i++] = query;
					} else if (request.getParameter("editInformationForm").equals("editFlight")) {
						if (!request.getParameter("departureTime").isEmpty()) {
							query = String.format("UPDATE Flight SET DepartureTime=\"%s\" WHERE FlightNumber=%s;", request.getParameter("departureTime"), request.getParameter("flightNumber"));
							queries[i++] = query;
						}
						if (!request.getParameter("arrivalTime").isEmpty()) {
							query = String.format("UPDATE Flight SET ArrivalTime=\"%s\" WHERE FlightNumber=%s;", request.getParameter("arrivalTime"), request.getParameter("flightNumber"));
							queries[i++] = query;
						}
						if (!request.getParameter("flightType").isEmpty()) {
							query = String.format("UPDATE Flight SET Type=\"%s\" WHERE FlightNumber=%s;", request.getParameter("flightType"), request.getParameter("flightNumber"));
							queries[i++] = query;
						}
					}
					try {
						for (int j = 0; j < i; j++) {
				            st = con.createStatement();
				            st.execute(queries[j]);
				            st.close();
						}
						out.println("<script>document.getElementById(\"editFormSuccessMsg\").innerHTML=\"Query was successful\"</script>");
					} catch (Exception e) {
						out.println("<script>document.getElementById(\"editFormErrorMsg\").innerHTML=\"There was an error when performing your query\"</script>");
					}
				}
   			%>

		<div>
			<h2>Aircraft:</h2>
			<form id="addAircraftForm" method="POST">
				<h3>Add Aircraft</h3>
				<input type="hidden" name="formType" value="editInformationForm" />
				<input type="hidden" name="editInformationForm" value="addAircraft" />
				<input type="number" placeholder="Aircraft ID" name="acid" required />
				<input type="number" placeholder="Model Number" name="modelNumber"
					required /> <input type="text" placeholder="Manufacturer"
					name="manufacturer" required /> <input type="number"
					placeholder="Capacity" name="capacity" required />
				<button>Add Aircraft</button>
			</form>

			<form id="editAircraftForm" method="POST">
				<h3>Edit Aircraft</h3>
				<p>*Note: All fields below aside from Aircraft ID are optional, however one additional field must be filled out in order to make change*</p>
				<input type="hidden" name="formType" value="editInformationForm" />
				<input type="hidden" name="editInformationForm" value="editAircraft" />
				<input type="number" placeholder="Aircraft ID" name="acid" required />
				<input type="number" placeholder="New Model Number" name="modelNumber" /> 
				<input type="text" placeholder="New Manufacturer" name="manufacturer" /> 
				<input type="number" placeholder="New Capacity" name="capacity" />
				<button>Edit Aircraft</button>
			</form>

			<form id="deleteAircraftForm" method="POST">
				<h3>Delete Aircraft</h3>
				<input type="hidden" name="formType" value="editInformationForm" />
				<input type="hidden" name="editInformationForm"
					value="deleteAircraft" /> <input type="number"
					placeholder="Aircraft ID" name="acid" />
				<button>Delete Aircraft</button>
			</form>
		</div>

		<div>
			<h2>Airport</h2>
			<form id="addAirportForm" method="POST">
				<h3>Add Airport</h3>
				<input type="hidden" name="formType" value="editInformationForm" />
				<input type="hidden" name="editInformationForm" value="addAirport" />
				<input type="text" placeholder="Airport ID" name="apid" required />
				<input type="text" placeholder="Airport Address" name="address"	required /> 
				<input type="text" placeholder="Airport Name" name="name" required />
				<button>Add Airport</button>
			</form>

			<form id="editAirportForm" method="POST">
				<h3>Edit Airport</h3>
				<input type="hidden" name="formType" value="editInformationForm" />
				<input type="hidden" name="editInformationForm" value="editAirport" />
				<input type="text" placeholder="Airport ID" name="apid" required />
				<input type="text" placeholder="New Airport Address" name="address" /> 
				<input type="text" placeholder="New Airport Name" name="name" />
				<button>Edit Airport</button>
			</form>

			<form id="deleteAirportForm" method="POST">
				<h3>Delete Airport</h3>
				<input type="hidden" name="formType" value="editInformationForm" />
				<input type="hidden" name="editInformationForm"
					value="deleteAirport" /> <input type="text"
					placeholder="Airport ID" name="apid" />
				<button>Delete Airport</button>
			</form>
		</div>

		<div>
			<h2>Flight</h2>
			<form id="addFlightForm" method="POST">
				<h3>Add Flight</h3>
				<input type="hidden" name="formType" value="editInformationForm" />
				<input type="hidden" name="editInformationForm" value="addFlight" />
				<p>Note: Flight Number must be greater than 0</p>
				<input type="number" placeholder="Flight Number" name="flightNumber" required /> <br> 
				Departure Time: <input type="datetime-local" placeholder="Departure Time" name="departureTime" required /> <br> 
				Arrival Time:<input type="datetime-local" placeholder="Arrival Time" name="arrivalTime"	required /><br> 
				<input type="radio" name="flightType" value="local"	required />Local<br> 
				<input type="radio" name="flightType" value="international" required />International<br>
				<button>Add Flight</button>
			</form>

			<form id="editFlightForm" method="POST">
				<h3>Edit Flight</h3>
				<input type="hidden" name="formType" value="editInformationForm" />
				<input type="hidden" name="editInformationForm" value="editFlight" />
				<input type="number" placeholder="Flight Number" name="flightNumber" required /> <br> 
				Departure Time: <input type="datetime-local" placeholder="New Departure Time" name="departureTime" /> <br> 
				Arrival Time:<input type="datetime-local" placeholder="New Arrival Time" name="arrivalTime"	/><br> 
				<input type="radio" name="flightType" value="local"	/>Local<br> 
				<input type="radio" name="flightType" value="international" />International<br>
				<button>Edit Flight</button>
			</form>

			<form id="deleteFlightForm" method="POST">
				<h3>Delete Flight</h3>
				<input type="hidden" name="formType" value="editInformationForm" />
				<input type="hidden" name="editInformationForm" value="deleteFlight" />
				<input type="number" placeholder="Flight Number" name="flightNumber" />
				<button>Delete Flight</button>
			</form>
		</div>
	</div>










































	<form id="waitlistForm" method="POST">
		<h1>Edit Reservations</h1>
		<input type="hidden" name="formType" value="waitlistForm" /> <input
			id="flightNumber" type="number" placeholder="Flight Number"
			name="flightNumber" required /><br>
			<%		
	    			String fNumber = request.getParameter("flightNumber");
	    			if (fNumber != null) {
	    				if (Integer.parseInt(fNumber) != 0) {
	    					out.println("<h3>Flight Number " + fNumber + " Waitlist</h3>");
		                    Class.forName("com.mysql.jdbc.Driver").newInstance();
		                    con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
		                    st = con.createStatement();
		    				query = String.format("SELECT email FROM Waitlist WHERE FlightNumber=\"%s\"", fNumber);
		    				rs = st.executeQuery(query);
		    				boolean noResults = true;
		    				out.println("<table border='1px solid black'><th>Emails</th>");
		    				while (rs.next()) {
		    					out.println(String.format("<tr><td>%s</td></tr>", rs.getString("email")));
		    					noResults = false;
		    				}
		    				if (noResults) {
		    					out.println("<tr><td>No one is on this waitlist</td></tr>");
		    				}
		    				out.println("</table>");
	    				}
	    			}
	    		%>
		<button>Get Waitlist</button>
	</form>
	<%= "<script>hideForms(" + request.getParameter("formType") + ")</script>" %>
</body>
<a href="logout.jsp">Logout</a>
</html>