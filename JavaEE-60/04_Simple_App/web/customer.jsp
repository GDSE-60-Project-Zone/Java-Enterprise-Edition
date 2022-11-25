<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.CustomerDTO" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Manage</title>
    <meta content="width=device-width initial-scale=1" name="viewport">
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/styles.css" rel="stylesheet">
    <link crossorigin="anonymous" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css"
          integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" rel="stylesheet">
    <style>
        ul > li {
            cursor: pointer;
        }
    </style>
</head>
<body>
<%




//    ArrayList<CustomerDTO> allCustomers= new ArrayList<>();

    ArrayList<CustomerDTO> allCustomers = (ArrayList<CustomerDTO>) request.getAttribute("customers");

//    allCustomers.add(new CustomerDTO("C001","Sadun","Galle",1000));
//    allCustomers.add(new CustomerDTO("C002","Ashan","Galle",3000));
//    allCustomers.add(new CustomerDTO("C003","Pasan","Galle",4000));
//    allCustomers.add(new CustomerDTO("C004","Nimesh","Galle",51000));
//    allCustomers.add(new CustomerDTO("C005","Uvindu","Galle",6000));






%>
<!--header-->
<header class="jumbotron bg-primary text-white p-3">
    <h1 class="position-absolute" id="nav"></h1>
    <ul class="list-group list-group-horizontal text-danger justify-content-end font-weight-bold">
        <li class="list-group-item bg-white" id="lnkHome"><a href="index.html">Home</a></li>
        <li class="list-group-item bg-danger text-white" id="lnkCustomer"><a class="text-white" href="customer.jsp">Customer</a>
        </li>
        <li class="list-group-item bg-white" id="lnkItem"><a href="item.html">Item</a></li>
        <li class="list-group-item bg-white" id="lnkOrders"><a href="purchase-order.html">Orders</a></li>
    </ul>
</header>

<!--customer content-->
<main class="container-fluid" id="customerContent">
    <section class="row">
        <div class="col-4">
            <h1>Customer Registraion</h1>
            <form id="customerForm">
            <div class="form-group">
                <label for="txtCustomerID">Customer ID</label>
                <input class="form-control" id="txtCustomerID"  type="text" name="id">
                <span class="control-error" id="lblcusid"></span>
            </div>
            <div class="form-group">
                <label for="txtCustomerName">Customer Name</label>
                <input class="form-control" id="txtCustomerName" type="text" name="name">
                <span class="control-error" id="lblcusname"></span>
            </div>
            <div class="form-group">
                <label for="txtCustomerAddress">Customer Address</label>
                <input class="form-control" id="txtCustomerAddress" type="text" name="address">
                <span class="control-error" id="lblcusaddress"></span>
            </div>
            <div class="form-group">
                <label for="txtCustomerSalary">Customer Salary</label>
                <input class="form-control" id="txtCustomerSalary" type="text" name="salary">
                <span class="control-error" id="lblcussalary"></span>
            </div>
            </form>
            <div class="btn-group">
                <button class="btn btn-primary" id="btnCustomer" form="customerForm" formaction="customer?option=add" formmethod="post">Save Customer</button>
                <button class="btn btn-danger" id="btnCusDelete" form="customerForm" formaction="customer?option=remove" formmethod="post">Remove</button>
                <button class="btn btn-warning" id="btnUpdate" form="customerForm" formaction="customer?option=update" formmethod="post">Update</button>
                <button class="btn btn-success" id="btnGetAll" form="customerForm" formaction="customer">Get All</button>
                <button class="btn btn-danger" id="btn-clear1">Clear All</button>
            </div>

        </div>
        <div class="col-8">
            <table class="table table-bordered table-hover">
                <thead class="bg-danger text-white">
                <tr>
                    <th>Customer ID</th>
                    <th>Customer Name</th>
                    <th>Customer Address</th>
                    <th>Customer Salary</th>
                </tr>
                </thead>
                <tbody id="tblCustomer">
                    <%
                        if(allCustomers!=null){
                                for (CustomerDTO customer : allCustomers) {
                    %>
                  <tr>
                      <td><%=customer.getId()%></td>
                      <td><%=customer.getName()%></td>
                      <td><%=customer.getAddress()%></td>
                      <td><%=customer.getSalary()%></td>
                  </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </section>
</main>


<script src="assets/js/jquery-3.6.1.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script>
    //select the save button and bind a click event for it

    // var customers = []; // global scope (Store all the customer records)
    //
    // //Button Events
    // $("#btnCustomer").click(function () {
    //     //local scope // function scope
    //
    //     //select all the four text fields and then get their typed values
    //     let customerID = $("#txtCustomerID").val();
    //     let customerName = $("#txtCustomerName").val();
    //     let customerAddress = $("#txtCustomerAddress").val();
    //     let customerSalary = $("#txtCustomerSalary").val();
    //
    //     // alert(customerID+" "+ customerName+" "+customerAddress+" "+customerSalary);
    //
    //     //Put all of these values inside a named container
    //     // customer
    //
    //     var customerObject = {
    //         id: customerID,
    //         name: customerName,
    //         address: customerAddress,
    //         salary: customerSalary
    //     }
    //
    //     //add the customer object to the array
    //     customers.push(customerObject);
    //
    //
    //     // console.log(customers);
    //
    //     loadAllCustomers();
    //
    //     bindRowClickEvents();
    //
    // });
    //
    // $("#btnCusDelete").click(function () {
    //     let deleteID = $("#txtCustomerID").val();
    //
    //     let option = confirm("Do you really want to delete customer id :" + deleteID);
    //     if (option){
    //         if (deleteCustomer(deleteID)) {
    //             alert("Customer Successfully Deleted..");
    //             setTextfieldValues("", "", "", "");
    //         } else {
    //             alert("No such customer to delete. please check the id");
    //         }
    //     }
    // });
    //
    // $("#btnGetAll").click(function () {
    //     loadAllCustomers();
    // });
    //
    // $("#btnUpdate").click(function () {
    //     let customerID = $("#txtCustomerID").val();
    //     let response = updateCustomer(customerID);
    //     if (response) {
    //         alert("Customer Updated Successfully");
    //         setTextfieldValues("", "", "", "");
    //     } else {
    //         alert("Update Failed..!");
    //
    //     }
    // });
    //
    //
    // //load all customers
    // function loadAllCustomers() {
    //     //remove all the table body content before adding data
    //     $("#tblCustomer").empty();
    //
    //
    //     // get all customer records from the array
    //     for (var customer of customers) {
    //         // console.log(customer);// customer object
    //
    //         // add those data to the table row
    //         // var row= "<tr><td>"+customer.id+"</td><td>"+customer.name+"</td><td>"+customer.address+"</td><td>"+customer.salary+"</td></tr>";
    //
    //         // Using String Literals to do the same thing as above
    //         var row = `<tr><td>${customer.id}</td><td>${customer.name}</td><td>${customer.address}</td><td>${customer.salary}</td></tr>`;
    //
    //         //then add it to the table body of customer table
    //         $("#tblCustomer").append(row);
    //     }
    // }
    //
    //
    // //Set back values from table to text fields
    // // $('tr'); // select all the rows
    //
    // // $("#tblCustomer>tr").click(function () {
    // //     //how to get the row we click at the moment
    // //     console.log(this); // we can use this // return tr dom object
    // // });
    //
    // // //to access jQuery method we have to convert the dom object to the jQuery Object
    // // $("#tblCustomer>tr").click(function () {
    // //     //how to get the row we click at the moment
    // //     console.log($(this)); // now the clicked dom object will convert into jQuery object and then will
    // //     // Allow you to access jQuery methods
    // // });
    //
    // //So let's print the row details which we clicked
    // // $("#tblCustomer>tr").click(function () {
    // //     //how to get the row we click at the moment
    // //     let rowData = $(this).text(); // this will return the entire row text which is clicked
    // //     console.log(rowData);
    // // });
    //
    // // So we don't want entire row text we want only segregated data
    //
    //
    function bindRowClickEvents() {
        $("#tblCustomer>tr").click(function () {
            let id = $(this).children(":eq(0)").text();
            let name = $(this).children(":eq(1)").text();
            let address = $(this).children(":eq(2)").text();
            let salary = $(this).children(":eq(3)").text();
            // console.log(id, name, address, salary);

            //setting table details values to text fields
            $('#txtCustomerID').val(id);
            $('#txtCustomerName').val(name);
            $('#txtCustomerAddress').val(address);
            $('#txtCustomerSalary').val(salary);

        });
    }
    bindRowClickEvents();
    //
    // $("#txtCustomerID").on('keyup', function (event) {
    //     if (event.code == "Enter") {
    //         let typedId = $("#txtCustomerID").val();
    //         let customer = searchCustomer(typedId);
    //         if (customer != null) {
    //             setTextfieldValues(customer.id, customer.name, customer.address, customer.salary);
    //         } else {
    //             alert("There is no cusotmer available for that " + typedId);
    //             setTextfieldValues("", "", "", "");
    //         }
    //     }
    // });
    //
    //
    // function setTextfieldValues(id, name, address, salary) {
    //     $("#txtCustomerID").val(id);
    //     $("#txtCustomerName").val(name);
    //     $("#txtCustomerAddress").val(address);
    //     $("#txtCustomerSalary").val(salary);
    // }
    //
    //
    // function searchCustomer(cusID) {
    //     for (let customer of customers) {
    //         if (customer.id == cusID) {
    //             return customer;
    //         }
    //     }
    //     return null;
    // }
    //
    // function deleteCustomer(customerID) {
    //     let customer = searchCustomer(customerID);
    //     if (customer != null) {
    //         let indexNumber = customers.indexOf(customer);
    //         customers.splice(indexNumber, 1);
    //         loadAllCustomers();
    //         return true;
    //     } else {
    //         return false;
    //     }
    // }
    //
    // function updateCustomer(customerID) {
    //     let customer = searchCustomer(customerID);
    //     if (customer != null) {
    //         customer.id = $("#txtCustomerID").val();
    //         customer.name = $("#txtCustomerName").val();
    //         customer.address = $("#txtCustomerAddress").val();
    //         customer.salary = $("#txtCustomerSalary").val();
    //         loadAllCustomers();
    //         return true;
    //     } else {
    //         return false;
    //     }
    //
    // }

</script>
</body>
</html>
