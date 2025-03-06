import 'package:dart_frog/dart_frog.dart';
import '../../database/db.dart';


Future<Response> onRequest(
  RequestContext context,
  String id,
)async{
  return switch (context.request.method) {
    HttpMethod.delete => _deleteUser(id),
    HttpMethod.put => _updateUser(id, context),
    _ => Future.value(Response(body: 'This is default')),
  };
}

Future<Response> _deleteUser(String id) async {
  try {
    // Open the database connection
    final connection = await Database.openConnection();

    // Execute DELETE query
    final rowsAffected = await connection.execute(
      r'DELETE FROM users WHERE id = $1',
      parameters: [int.parse(id)],
    );

    await connection.close();

    // Check if the user was deleted
    if (rowsAffected.affectedRows > 0) {
      return Response.json(
        body: {
          'message': 'User $id deleted successfully!',
        },
      );
    } else {
      return Response.json(
        statusCode: 404,
        body: {'error': 'User not found'},
      );
    }
  } catch (e) {
    print('Error: $e');
    return Response.json(
      statusCode: 500,
      body: {'error': 'Failed to delete user: ${e.toString()}'},
    );
  }
}

Future<Response> _updateUser(String id, RequestContext context) async {
  try {
    // Parse and validate the request body
    final json = (await context.request.json()) as Map<String, dynamic>;
    final firstName = json['first_name'];
    final lastName = json['last_name'];
    final age = json['age'];
    final email = json['email'];
    final password = json['password'];

    // Ensure at least one field is being updated
    if (firstName == null &&
        lastName == null &&
        age == null &&
        email == null &&
        password == null) {
      return Response.json(
        statusCode: 400,
        body: {'error': 'No fields provided for update'},
      );
    }

    // Build the dynamic SQL update query
    final updates = <String>[];
    final values = <dynamic>[];
    if (firstName != null) {
      updates.add('first_name = \$${updates.length + 1}');
      values.add(firstName);
    }
    if (lastName != null) {
      updates.add('last_name = \$${updates.length + 1}');
      values.add(lastName);
    }
    if (age != null) {
      updates.add('age = \$${updates.length + 1}');
      values.add(age);
    }
    if (email != null) {
      updates.add('email = \$${updates.length + 1}');
      values.add(email);
    }
    if (password != null) {
      updates.add('password = \$${updates.length + 1}');
      values.add(password);
    }
    values.add(int.parse(id)); // Add the `id` parameter as the last value

    final connection = await Database.openConnection();

    // Execute the UPDATE query
    final rowsAffected = await connection.execute(
      'UPDATE users SET ${updates.join(', ')} WHERE id = \$${updates.length + 1}',
      parameters: values,
    );

    await connection.close();

    if (rowsAffected.affectedRows > 0) {
      return Response.json(
        body: {
          'message': 'User $id updated successfully!',
        },
      );
    } else {
      return Response.json(
        statusCode: 404,
        body: {'error': 'User not found'},
      );
    }
  } catch (e) {
    print('Error: $e');
    return Response.json(
      statusCode: 500,
      body: {'error': 'Failed to update user: ${e.toString()}'},
    );
  }
}
