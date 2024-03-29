# Attendence Applicaiton

An application that can be used by employees to record attendance using facial recognition.
### Features

The **features** of the application are,
+ Authentication of an employee based on facial recognition and geolocation. The application checks whether the employee is inside the office while recording attendance.
+ Registration of employees with face and office geolocation.
+ Feature to view attendance recorded by the employee.
+ Feature to update the details of employees with certain concerns.

### Workflow
The **workflow** of the application is as follows,

+ Employees should register themself from the office as the current location is captured during registration and further attendance can be made only from this location.
+ For employees with work-from-home case scenarios, barcode-based authentication is also provided.
+ Employees can log in themself with their email and password.
+ Employee can scan their face to mark attendance. The work-from-home option should be enabled through the website by the manager and in such cases, the employee can perform a barcode-based login.
+ For in-office employees geolocation is also checked during attendance.
+ The employee can check in and check out to record attendance.
+ The employee can view his attendance based on the month.
+ The employee can also change his data at most once through the application.


### Database setup

Firebase is being used as a database for this application. The schema is,
+ Employee collection with auto-generated id. The document in employee has the following values,

```json
{
  "WorkType": "in-office",
  "address": "",
  "birthDate": "02/28/2023",
  "canEdit": false,
  "firstName": "hari",
  "id": "hari@gmail.com",
  "lastName": "hara sankar",
  "lat": 11.4958421,
  "lon": 77.2761778,
  "password": "12345678"
}
```
The password must be stored in an encrypted format. This is just shown for reference, but we can use firebase authentication services to manage users.

+ A record sub-collection of the employee collection.
+ The record sub-collection will have the date of attendance as the document ID.
+ The document has the following value,

```json
{
  "checkIn": "04:11",
  "checkInLocation": "BIT-IT Lab, Tamil Nadu, 638401, India",
  "checkOut": "04:13",
  "checkOutLocation": "BIT-IT Lab, Tamil Nadu, 638401, India",
  "date": "March 20,2023 at 4: 13: 00 PM U"
}
```
The date is stored as a timestamp in firebase.

Also, enable signIn using email in the authentication section of firebase.
Register your app with the package name `com.bytx.attendanceapp` and place the `google-services.json` file in the `/android/app/` folder.

## Images

![Login page](https://github.com/harisankar01/Attendance-app/assets/90249023/41962a7a-9749-4b6c-a05c-444d3b5b22ad)
![Home](https://github.com/harisankar01/Attendance-app/assets/90249023/77faefac-5dbf-4c50-a831-4f1853892ed9)
![Facial Recognition](https://github.com/harisankar01/Attendance-app/assets/90249023/5fc03b28-5c69-4b61-b708-928b2baf9dfa)
![Home](https://github.com/harisankar01/Attendance-app/assets/90249023/a879417d-9a3d-4a99-9dfb-021be272883b)
![Location Service](https://github.com/harisankar01/Attendance-app/assets/90249023/4f1ca5f2-9d5a-4dd7-ae4a-27261210637e)
![Office Check](https://github.com/harisankar01/Attendance-app/assets/90249023/e306c824-4e2a-40b3-aa89-b011b8e74723)
![Profile](https://github.com/harisankar01/Attendance-app/assets/90249023/7a541424-93ff-4e74-8c3e-590a2c86ab0b)
