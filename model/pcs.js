const db = require('../db');

// Fungsi untuk mengambil semua PC
exports.getAllPCs = async () => {
  const query = 'SELECT * FROM pcs';
  try {
    const [results] = await db.query(query);
    return results;
  } catch (err) {
    console.error('Error fetching PCs:', err);
    throw new Error('Failed to fetch PCs');
  }
};

// Fungsi untuk memperbarui status PC
exports.updatePCStatus = async (id, status) => {
  const query = 'UPDATE pcs SET status = ? WHERE id = ?';
  try {
    const [results] = await db.query(query, [status, id]);
    return results;
  } catch (err) {
    console.error('Error updating PC status:', err);
    throw new Error('Failed to update PC status');
  }
};

// Fungsi untuk menghapus PC berdasarkan ID
exports.deletePCById = async (id) => {
  const query = 'DELETE FROM pcs WHERE id = ?';
  try {
    const [result] = await db.query(query, [id]);
    return result;
  } catch (err) {
    console.error('Error deleting PC:', err);
    throw new Error('Failed to delete PC');
  }
};