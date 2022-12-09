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
                    <input class="form-control" id="txtCustomerID" type="text" name="id">
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
                <button class="btn btn-primary" type="button" id="btnCustomer">Save Customer</button>
                <button class="btn btn-danger" type="button" id="btnCusDelete">Remove</button>
                <button class="btn btn-warning" type="button" id="btnUpdate">Update</button>
                <button class="btn btn-success" type="button" id="btnGetAll">Get All</button>
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
                    if (allCustomers != null) {
                        for (CustomerDTO customer : allCustomers) {
                %>
                <tr>
                    <td><%=customer.getId()%>
                    </td>
                    <td><%=customer.getName()%>
                    </td>
                    <td><%=customer.getAddress()%>
                    </td>
                    <td><%=customer.getSalary()%>
                    </td>
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

    //load all customers from the database
    getAllCustomers();


    //Button Events
    //Add Customer
    $("#btnCustomer").click(function () {
        let formData = $("#customerForm").serialize();
        $.ajax({
            url: "customer",
            method: "post",
            data: formData,
            dataType:"json",
            success: function (res) {
                // invoked if the response status code is in 200 range
                console.log("Success Method Invoked")
                console.log(res);
                alert(res.message);
                getAllCustomers();
            },
            error:function(error){
                // invokes if status code range is 500 range or 400 range
                console.log("Error Method Invoked");
                console.log(JSON.parse(error.responseText));
                alert(JSON.parse(error.responseText).message);

            }
        });

    });

    //Delete Customer
    $("#btnCusDelete").click(function () {
        let id = $("#txtCustomerID").val();
        $.ajax({
            url: "customer?id=" + id,
            method: "delete",
            success: function (resp) {
                getAllCustomers();
            }
        });
    });

    //Update Customer
    $("#btnUpdate").click(function () {
        let cusId = $("#txtCustomerID").val();
        let cusName = $("#txtCustomerName").val();
        let cusAddress = $("#txtCustomerAddress").val();
        let cusSalary = $("#txtCustomerSalary").val();

        var customerOb = {
            id: cusId,
            name: cusName,
            address: cusAddress,
            salary: cusSalary
        }
        $.ajax({
            url: "customer",
            method: "put",
            contentType:"application/json",
            data: JSON.stringify(customerOb),
            success: function (res) {
                getAllCustomers();
            }
        });
    });

    //Get All Customer
    $("#btnGetAll").click(function () {
        getAllCustomers();
    });

    //Get all Customer Function
    function getAllCustomers() {
        $("#tblCustomer").empty();
        $.ajax({
            url: "customer",
            success: function (res) {
                for (let c of res) {
                    let cusID = c.id;
                    let cusName = c.name;
                    let cusAddress = c.address;
                    let cusSalary = c.salary;

                    let row = "<tr><td>" + cusID + "</td><td>" + cusName + "</td><td>" + cusAddress + "</td><td>" + cusSalary + "</td></tr>";
                    $("#tblCustomer").append(row);
                }
                bindRowClickEvents();
                setTextFieldValues("", "", "", "");
            }
        });
    }

    //Bind events for the table rows function
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

    //Set text fields values function
    function setTextFieldValues(id, name, address, salary) {
        $("#txtCustomerID").val(id);
        $("#txtCustomerName").val(name);
        $("#txtCustomerAddress").val(address);
        $("#txtCustomerSalary").val(salary);
    }

</script>
</body>
</html>
