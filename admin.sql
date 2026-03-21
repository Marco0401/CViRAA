-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Mar 20, 2026 at 03:41 PM
-- Server version: 10.11.14-MariaDB-cll-lve
-- PHP Version: 8.4.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `depedcarcarcity_cat`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL COMMENT 'Hashed password',
  `profile_picture` varchar(255) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL COMMENT 'Full name of admin/coach',
  `role` enum('superadmin','admin','coach','official','staff') DEFAULT 'admin' COMMENT 'User role: superadmin=full access, admin=standard, coach=sport-only, staff=scanner only',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `sport_category` varchar(100) DEFAULT NULL COMMENT 'Sport category for coach accounts (e.g. BASKETBALL, VOLLEYBALL)',
  `plain_password` varchar(255) DEFAULT NULL,
  `terms_accepted_at` datetime DEFAULT NULL COMMENT 'Timestamp when user first accepted the Terms & Conditions. NULL = not yet accepted.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`, `profile_picture`, `full_name`, `role`, `created_at`, `sport_category`, `plain_password`, `terms_accepted_at`) VALUES
(2, 'admin', '$2y$10$5ZCu751yXQxmjlQ8NLlvXu8JetjR7pqp.QzJMmZx5vzWn4QxTxmeW', 'uploads/admin_profiles/admin_2_1772758819.jpg', NULL, 'superadmin', '2026-03-05 00:56:10', NULL, 'deped123', '2026-03-20 07:54:24'),
(96, 'arnis_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'JANE  BALANSAG, KARL NIKKO  RESURRECCION, KIMBERLY FLORES, MARY ANN GEMOTA', 'coach', '2026-03-18 02:38:15', 'ARNIS', 'deped123', '2026-03-20 08:48:52'),
(97, 'athletics_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'ANALYN MINOR, CHERYL RAMOS, ELANNIENE PUERTO, JULIUS CORTES, ROSELYN YORONG, Test_Coach', 'coach', '2026-03-18 02:38:15', 'ATHLETICS', 'deped123', NULL),
(98, 'athletics15b_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'JESSAH MAE GAÑOLON, MELYN ANTONI', 'coach', '2026-03-18 02:38:15', 'ATHLETICS - 15 BELOW - BOYS - ID', 'deped123', NULL),
(99, 'badminton_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'FREYA MAE FERNANDEZ, METCHIE JANE BORJA, MICHAELA MAREE SEBIAL, VANGIE FERNANDEZ', 'coach', '2026-03-18 02:38:15', 'BADMINTON', 'deped123', NULL),
(100, 'baseball_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, '', 'coach', '2026-03-18 02:38:15', 'BASEBALL', 'deped123', NULL),
(101, 'basketball_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'AIA OBISO, ALVA PILLERIN', 'coach', '2026-03-18 02:38:15', 'BASKETBALL', 'deped123', NULL),
(102, 'basketball3x3_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'DAISY OAPER, GIDEON KEM UBALDE', 'coach', '2026-03-18 02:38:15', 'BASKETBALL 3X3', 'deped123', NULL),
(103, 'billiards_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'AISA NIÑA  DAMAYO, RENABETH AREMON', 'coach', '2026-03-18 02:38:15', 'BILLIARDS', 'deped123', NULL),
(104, 'boxing_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'LOUELLA EMBUSCADO', 'coach', '2026-03-18 02:38:15', 'BOXING', 'deped123', NULL),
(105, 'chess_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'ADEMA RESURRECION, CHARITO SOBREVILLA, GRACE CAROL LEQUIN, LENI RAMA', 'coach', '2026-03-18 02:38:15', 'CHESS', 'deped123', NULL),
(106, 'dancesports_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'ANGELO LLANOS, ANGELO LLANOS', 'coach', '2026-03-18 02:38:15', 'DANCESPORTS', 'deped123', NULL),
(107, 'football_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'GODWIN SECUSANA, JASON CARLO MONTESCLAROS', 'coach', '2026-03-18 02:38:16', 'FOOTBALL', 'deped123', NULL),
(108, 'futsal_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'DIANE SATUMCACAL, TESSA DAHL CAMPOS', 'coach', '2026-03-18 02:38:16', 'FUTSAL', 'deped123', NULL),
(109, 'pencaksilat_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'CARLOS JR. MONISIT, CARLOS JR. MONISIT', 'coach', '2026-03-18 02:38:16', 'PENCAK SILAT', 'deped123', NULL),
(110, 'sepaktakraw_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'ISARAEL CANQUE, JESSA ROSALIE ARUTA, JUNRY EÑEGO', 'coach', '2026-03-18 02:38:16', 'SEPAK TAKRAW', 'deped123', '2026-03-20 14:57:35'),
(111, 'softball_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, '', 'coach', '2026-03-18 02:38:16', 'SOFTBALL', 'deped123', NULL),
(112, 'swimming_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'APRIL MARISE JIMENO, CLOUE FAYE TUMULAK, LANNI  DORIA, MA. LOIDA ALCORDO', 'coach', '2026-03-18 02:38:16', 'SWIMMING', 'deped123', NULL),
(113, 'tabletennis_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'FELYN MAE BOISER, JENELYN ABAÑO, MARIA VICTORIA RACOMA, RONALD CAMPUGAN', 'coach', '2026-03-18 02:38:16', 'TABLE TENNIS', 'deped123', NULL),
(114, 'taekwondo_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'EDYZA FATIMA RENSULAT, JEANLY PEARL LAWAS, ORLENE  CANAPE, SHERYL BETONTA', 'coach', '2026-03-18 02:38:16', 'TAEKWONDO', 'deped123', NULL),
(115, 'tennis_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'JENNIE YBAÑEZ, JENNIFER SAAVEDRA, JHUN MARK SASAN, NIÑA CHRISTY LEDESMA', 'coach', '2026-03-18 02:38:16', 'TENNIS', 'deped123', NULL),
(116, 'volleyball_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'JUNELLE AMANCE, MARIZEL SABUSAB, MICHAEL SATINITIGAN, RHODA LABASAN', 'coach', '2026-03-18 02:38:16', 'VOLLEYBALL', 'deped123', NULL),
(117, 'other_coach', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, '', 'coach', '2026-03-18 02:38:16', 'OTHER', 'deped123', NULL),
(118, 'depedcarcar_admin', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'Michael Elmer Padin', 'superadmin', '2026-03-19 09:23:55', NULL, 'deped123', NULL),
(119, 'deped@scanner', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'Staff', 'staff', '2026-03-20 06:28:43', NULL, 'deped123', '2026-03-20 08:03:06'),
(120, 'scanner@deped', '$2y$10$/prULNRMHX7RpwE0cO.1t.L/xgQdWJHHAoPnUvXeBsrwRvdFcIMi2', NULL, 'staff', 'staff', '2026-03-20 08:46:29', NULL, 'deped123', '2026-03-20 09:57:19');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
