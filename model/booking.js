const db = require('../db'); 


// Fungsi untuk menambahkan booking baru
exports.createBooking = async (bookingData) => {
  const query = `
    INSERT INTO bookings (user_id, total_price, status, created_at, selected_pcs)
    VALUES (?, ?, 'pending', NOW(), ?)
  `;
  const params = [
    bookingData.userId,
    bookingData.totalPrice,
    JSON.stringify(bookingData.selectedPCs), 
  ];

  try {
    const [results] = await db.query(query, params);
    console.log('Booking created successfully:', results);
    return results;
  } catch (err) {
    console.error('Error creating booking:', err);
    throw new Error('Failed to create booking');
  }
};

// Fungsi untuk mengambil semua booking
exports.getAllBookings = async () => {
  const query = 'SELECT * FROM bookings';

  try {
    const [results] = await db.query(query);  
    return results;
  } catch (err) {
    console.error('Error fetching bookings:', err);
    throw new Error('Failed to fetch bookings');
  }
};

// Fungsi untuk mengambil booking berdasarkan ID
exports.getBookingById = async (id) => {
  const query = 'SELECT * FROM bookings WHERE id = ?';

  try {
    const [results] = await db.query(query, [id]);  
    if (results.length === 0) {
      return null; 
    }
    return results[0];
  } catch (err) {
    console.error(`Error fetching booking by ID ${id}:`, err);
    throw new Error('Failed to fetch booking');
  }
};

// Fungsi untuk memperbarui status booking
exports.updateBookingStatus = async (id, status) => {
  const query = 'UPDATE bookings SET status = ? WHERE id = ?';

  try {
    const [results] = await db.query(query, [status, id]);
    console.log('Update results:', results);

    if (results.affectedRows === 0) {
      console.error(`No booking found with ID: ${id}`);
      return { error: 'No booking found with this ID' };
    }

    return results;
  } catch (err) {
    console.error('Error updating booking status:', err);
    throw new Error('Failed to update booking status');
  }
};


// Fungsi untuk mengambil history booking berdasarkan user
exports.getHistoryByUser = async (userId) => {
  const query = `
    SELECT id, user_id, total_price, status, created_at, updated_at, selected_pcs
    FROM bookings 
    WHERE user_id = ? 
    ORDER BY created_at DESC
  `;
  try {
    const [results] = await db.query(query, [userId]);
    console.log('Query executed for user_id:', userId);
    console.log('Query result:', results);

    if (!results || results.length === 0) {
      console.log(`No history found for user_id: ${userId}`);
      return [];
    }

    const parsedResults = results.map((booking) => ({
      ...booking,
      selected_pcs: booking.selected_pcs ? JSON.parse(booking.selected_pcs) : [],
    }));

    return parsedResults;
  } catch (err) {
    console.error('Error fetching history for user:', err);
    throw new Error('Failed to fetch booking history');
  }
};

// Fungsi untuk mendapatkan semua booking dengan status 'confirmed'

exports.getConfirmedBookings = async () => {
  const query = 'SELECT * FROM bookings WHERE status = "confirmed"';
  try {
    const [results] = await db.query(query);
    console.log('Confirmed bookings:', results);
    return results;
  } catch (err) {
    console.error('Error fetching confirmed bookings:', err);
    throw new Error('Failed to fetch confirmed bookings');
  }
};


// delete
exports.deleteBookingById = async (id) => {
  const query = 'DELETE FROM bookings WHERE id = ?';
  try {
    const [result] = await db.query(query, [id]);
    return result;
  } catch (err) {
    console.error('Error deleting booking:', err);
    throw new Error('Failed to delete booking');
  }
};
