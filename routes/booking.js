const express = require('express');
const router = express.Router();
const { createBooking, updateBookingStatus, getBookingById
  , getAllBookings,getHistoryByUser,getConfirmedBookings
  ,deleteBookingById  } = require('../model/booking');
  const { getAllPCs, updatePCStatus, deletePCById } = require('../model/pcs');

  
// Route untuk membuat booking baru
router.post('/', async (req, res) => {
  const { userId, selectedPCs, totalPrice } = req.body;

  if (!userId || !selectedPCs || !totalPrice) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  try {
    const bookingData = await createBooking({ userId, selectedPCs, totalPrice });

    res.status(201).json({
      message: 'Booking created successfully',
      bookingId: bookingData.insertId,
    });
  } catch (error) {
    console.error('Error creating booking:', error);
    res.status(500).json({ error: 'Failed to create booking' });
  }
});

// Route untuk Update status booking (update status pembayaran)
router.put('/:bookingId/payment', async (req, res) => {
  const { bookingId } = req.params;
  const { paymentStatus } = req.body;

  if (!paymentStatus || !bookingId) {
    return res.status(400).json({ error: 'Missing bookingId or paymentStatus' });
  }

  try {
    const booking = await getBookingById(bookingId);

    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    // Cek apakah status booking sudah 'confirmed'
    if (booking.status === 'confirmed') {
      return res.status(400).json({ error: 'Booking is already confirmed' });
    }

    // Update status booking
    const updateResult = await updateBookingStatus(bookingId, paymentStatus);

    if (updateResult.affectedRows === 0) {
      return res.status(500).json({ error: 'Failed to update booking status' });
    }

    res.status(200).json({
      message: `Booking payment status updated to ${paymentStatus}`,
      bookingId,
      updatedStatus: paymentStatus,
    });
  } catch (err) {
    console.error('Error updating booking status:', err);
    res.status(500).json({ error: 'Failed to update booking status' });
  }
});

// Route untuk get semua booking
router.get('/', async (req, res) => {
  try {
    const bookings = await getAllBookings();
    res.status(200).json(bookings);
  } catch (error) {
    console.error('Error fetching bookings:', error);
    res.status(500).json({ error: 'Failed to fetch bookings' });
  }
});


// Endpoint untuk mendapatkan history booking
router.get('/history/:id', async (req, res) => {
  const userId = req.params.id;

  console.log(`Received user_id: ${userId}`);
  if (!userId) {
    return res.status(400).json({ error: 'User ID is required' });
  }

  try {
    const history = await getHistoryByUser(userId); 
    console.log('Fetched booking history:', history);

    // Jika history kosong, responkan 404
    if (!history || history.length === 0) {
      return res.status(404).json({ error: 'No booking history found' });
    }

    res.status(200).json(history);
  } catch (err) {
    console.error('Error fetching history:', err);
    res.status(500).json({ error: 'Failed to fetch booking history' });
  }
});

// Route untuk mendapatkan booking dengan status 'confirmed'
router.get('/confirmed', async (req, res) => {
  try {
    const confirmedBookings = await getConfirmedBookings();

    if (!confirmedBookings || confirmedBookings.length === 0) {
      return res.status(404).json({ error: 'No confirmed bookings found' });
    }

    res.status(200).json(confirmedBookings);
  } catch (error) {
    console.error('Error fetching confirmed bookings:', error);
    res.status(500).json({ error: 'Failed to fetch confirmed bookings' });
  }
});


// Route untuk mendapatkan booking berdasarkan ID
router.get('/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const booking = await getBookingById(id);

    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    res.status(200).json(booking);
  } catch (error) {
    console.error('Error fetching booking:', error);
    res.status(500).json({ error: 'Failed to fetch booking' });
  }
});

// Route untuk menghapus booking
router.delete('/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const booking = await getBookingById(id);
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    const deleteResult = await deleteBookingById(id);
    if (deleteResult.affectedRows === 0) {
      return res.status(500).json({ error: 'Failed to delete booking' });
    }

    res.status(200).json({ message: 'Booking deleted successfully' });
  } catch (err) {
    console.error('Error deleting booking:', err);
    res.status(500).json({ error: 'Failed to delete booking' });
  }
});


//pcs
router.get('/alpha-pcs/booked', async (req, res) => {
  const query = "SELECT pc_number FROM pcs WHERE pc_type = 'Alpha' AND status = 'booked'";

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching data:', err);
      return res.status(500).json({ error: 'Failed to fetch data' });
    }

    // Return booked Alpha PCs
    res.json(results.map(row => row.pc_number));
  });
});

// router.get('/pcs', async (req, res) => {
//   try {
//     const pcs = await getAllPCs();
//     res.status(200).json(pcs);
//   } catch (error) {
//     console.error('Error fetching PCs:', error);
//     res.status(500).json({ error: 'Failed to fetch PCs' });
//   }
// });

// // Route untuk memperbarui status PC
// router.put('/pcs/:id', async (req, res) => {
//   const { id } = req.params;
//   const { status } = req.body;

//   if (!status) {
//     return res.status(400).json({ error: 'Status is required' });
//   }

//   try {
//     const updateResult = await updatePCStatus(id, status);

//     if (updateResult.affectedRows === 0) {
//       return res.status(404).json({ error: 'PC not found' });
//     }

//     res.status(200).json({
//       message: `PC ${id} status updated to ${status}`,
//     });
//   } catch (error) {
//     console.error('Error updating PC status:', error);
//     res.status(500).json({ error: 'Failed to update PC status' });
//   }
// });

module.exports = router;
